//
//  Client.swift
//  App
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Apollo
import Combine
import Foundation
import KeychainAccess

class Client {
    
    enum Error: Swift.Error {
        case invalidCredentials
    }
    
    static let shared = Client()
    
    private lazy var keychain: Keychain = {
        Keychain(service: "com.github.aplr.Richi.Example")
    }()
    
    private lazy var store: ApolloStore = {
        let cache = InMemoryNormalizedCache()
        return ApolloStore(cache: cache)
    }()
    
    private lazy var interceptorProvider: ClientInterceptorProvider = {
        ClientInterceptorProvider(
            client: self,
            keychain: keychain,
            urlSessionClient: URLSessionClient(),
            store: store
        )
    }()
    
    fileprivate lazy var apollo: ApolloClient = {
        let transport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: URL(string: "https://api.podchaser.com/graphql")!
        )
        
        return ApolloClient(
            networkTransport: transport,
            store: store
        )
    }()
    
    func getPodcast(id: String) -> Future<GetPodcastQuery.Data, Swift.Error> {
        Future<GetPodcastQuery.Data, Swift.Error> { promise in
            self.apollo.fetch(query: GetPodcastQuery(id: id), cachePolicy: .returnCacheDataElseFetch) {
                switch $0 {
                case let .failure(error):
                    promise(.failure(error))
                case let .success(result):
                    promise(.success(result.data!))
                }
            }
        }
    }
    
    func resetKeychain() {
        do {
            try keychain.removeAll()
        } catch {
            print("Error while removing all items from keychain.")
        }
    }
    
}

fileprivate class AddBearerTokenInterceptor: ApolloInterceptor {
    
    private let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        if let token = keychain["token"] {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
        }
    
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
    
}

fileprivate class RefreshBearerTokenInterceptor: ApolloInterceptor {
    
    private let client: Client
    private let keychain: Keychain
    
    init(client: Client, keychain: Keychain) {
        self.client = client
        self.keychain = keychain
    }
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        guard let error = response?.parsedResponse?.errors?.first else {
            chain.proceedAsync(request: request, response: response, completion: completion)
            return
        }
        
        guard error.message == "Invalid authorization request" else {
            chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            return
        }
        
        guard let info = Bundle.main.infoDictionary,
              let apiKey = info["ApiKey"] as? String,
              let apiSecret = info["ApiSecret"] as? String else {
            chain.handleErrorAsync(
                Client.Error.invalidCredentials,
                request: request,
                response: response,
                completion: completion
            )
            return
        }
        
        print(apiKey, apiSecret)
        
        let requestAccessToken = RequestAccessTokenMutation(id: apiKey, secret: apiSecret)
        
        client.apollo.perform(
            mutation: requestAccessToken,
            publishResultToStore: false
        ) {
            switch $0 {
            case let .failure(error):
                chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            case let .success(result):
                if let error = result.errors?.first {
                    chain.handleErrorAsync(error, request: request, response: response, completion: completion)
                    return
                }
                
                if let token = result.data?.requestAccessToken?.accessToken {
                    self.keychain["token"] = token
                }
                
                chain.retry(request: request, completion: completion)
            }
        }
    }
}

fileprivate class ClientInterceptorProvider: DefaultInterceptorProvider {
    
    private let client: Client
    private let keychain: Keychain
    
    init(client: Client, keychain: Keychain, urlSessionClient: URLSessionClient, store: ApolloStore) {
        self.client = client
        self.keychain = keychain
        super.init(client: urlSessionClient, shouldInvalidateClientOnDeinit: true, store: store)
    }
    
    override func interceptors<Operation>(
        for operation: Operation
    ) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        
        interceptors.insert(AddBearerTokenInterceptor(keychain: keychain), at: 0)
        
        if !(operation is RequestAccessTokenMutation) {
            interceptors.append(
                RefreshBearerTokenInterceptor(client: client, keychain: keychain)
            )
        }
        
        return interceptors
    }
    
}
