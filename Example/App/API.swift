// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetPodcastQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetPodcast($id: String!) {
      podcast(identifier: {id: $id, type: APPLE_PODCASTS}) {
        __typename
        id
        title
        imageUrl
        episodes(first: 10) {
          __typename
          paginatorInfo {
            __typename
            count
            currentPage
            firstItem
            hasMorePages
            lastItem
            lastPage
            perPage
            total
          }
          data {
            __typename
            id
            title
            audioUrl
            length
          }
        }
        author {
          __typename
          email
          name
        }
      }
    }
    """

  public let operationName: String = "GetPodcast"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("podcast", arguments: ["identifier": ["id": GraphQLVariable("id"), "type": "APPLE_PODCASTS"]], type: .object(Podcast.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(podcast: Podcast? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "podcast": podcast.flatMap { (value: Podcast) -> ResultMap in value.resultMap }])
    }

    /// Search for a specific podcast by Apple Podcast ID, Podchaser ID, RSS feed URL, and more.
    /// 
    /// Only available with certain permissions.
    public var podcast: Podcast? {
      get {
        return (resultMap["podcast"] as? ResultMap).flatMap { Podcast(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "podcast")
      }
    }

    public struct Podcast: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Podcast"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageUrl", type: .scalar(String.self)),
          GraphQLField("episodes", arguments: ["first": 10], type: .object(Episode.selections)),
          GraphQLField("author", type: .object(Author.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, imageUrl: String? = nil, episodes: Episode? = nil, author: Author? = nil) {
        self.init(unsafeResultMap: ["__typename": "Podcast", "id": id, "title": title, "imageUrl": imageUrl, "episodes": episodes.flatMap { (value: Episode) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Podchaser's internal podcast ID.
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The title of the podcast as specified in the RSS feed or podcast platform.
      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      /// The podcast artwork URL as specified in the RSS feed or podcast platform.
      public var imageUrl: String? {
        get {
          return resultMap["imageUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
        }
      }

      /// All the podcast's episodes.
      public var episodes: Episode? {
        get {
          return (resultMap["episodes"] as? ResultMap).flatMap { Episode(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "episodes")
        }
      }

      /// The author of the podcast as defined in the RSS feed.
      public var author: Author? {
        get {
          return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "author")
        }
      }

      public struct Episode: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EpisodeList"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
            GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
          self.init(unsafeResultMap: ["__typename": "EpisodeList", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Pagination information about the list of items.
        public var paginatorInfo: PaginatorInfo {
          get {
            return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
          }
        }

        /// A list of Episode items.
        public var data: [Datum] {
          get {
            return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
          }
        }

        public struct PaginatorInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PaginatorInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
              GraphQLField("firstItem", type: .scalar(Int.self)),
              GraphQLField("hasMorePages", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("lastItem", type: .scalar(Int.self)),
              GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
              GraphQLField("perPage", type: .nonNull(.scalar(Int.self))),
              GraphQLField("total", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(count: Int, currentPage: Int, firstItem: Int? = nil, hasMorePages: Bool, lastItem: Int? = nil, lastPage: Int, perPage: Int, total: Int) {
            self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "count": count, "currentPage": currentPage, "firstItem": firstItem, "hasMorePages": hasMorePages, "lastItem": lastItem, "lastPage": lastPage, "perPage": perPage, "total": total])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Number of items in the current page.
          public var count: Int {
            get {
              return resultMap["count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "count")
            }
          }

          /// Index of the current page.
          public var currentPage: Int {
            get {
              return resultMap["currentPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "currentPage")
            }
          }

          /// Index of the first item in the current page.
          public var firstItem: Int? {
            get {
              return resultMap["firstItem"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "firstItem")
            }
          }

          /// Are there more pages after this one?
          public var hasMorePages: Bool {
            get {
              return resultMap["hasMorePages"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasMorePages")
            }
          }

          /// Index of the last item in the current page.
          public var lastItem: Int? {
            get {
              return resultMap["lastItem"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "lastItem")
            }
          }

          /// Index of the last available page.
          public var lastPage: Int {
            get {
              return resultMap["lastPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "lastPage")
            }
          }

          /// Number of items per page.
          public var perPage: Int {
            get {
              return resultMap["perPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "perPage")
            }
          }

          /// Number of total available items.
          public var total: Int {
            get {
              return resultMap["total"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "total")
            }
          }
        }

        public struct Datum: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Episode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("audioUrl", type: .scalar(String.self)),
              GraphQLField("length", type: .scalar(Int.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, title: String, audioUrl: String? = nil, length: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "Episode", "id": id, "title": title, "audioUrl": audioUrl, "length": length])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Podchaser's internal episode ID.
          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// The title of the episode as specified in the RSS feed or podcast platform.
          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          /// The URL of the episode audio
          public var audioUrl: String? {
            get {
              return resultMap["audioUrl"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "audioUrl")
            }
          }

          /// The length of the audio in seconds
          public var length: Int? {
            get {
              return resultMap["length"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "length")
            }
          }
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EmailContact"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .scalar(String.self)),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(email: String? = nil, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "EmailContact", "email": email, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class RequestAccessTokenMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation RequestAccessToken($id: String!, $secret: String!) {
      requestAccessToken(
        input: {grant_type: CLIENT_CREDENTIALS, client_id: $id, client_secret: $secret}
      ) {
        __typename
        access_token
        token_type
        expires_in
      }
    }
    """

  public let operationName: String = "RequestAccessToken"

  public var id: String
  public var secret: String

  public init(id: String, secret: String) {
    self.id = id
    self.secret = secret
  }

  public var variables: GraphQLMap? {
    return ["id": id, "secret": secret]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("requestAccessToken", arguments: ["input": ["grant_type": "CLIENT_CREDENTIALS", "client_id": GraphQLVariable("id"), "client_secret": GraphQLVariable("secret")]], type: .object(RequestAccessToken.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(requestAccessToken: RequestAccessToken? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "requestAccessToken": requestAccessToken.flatMap { (value: RequestAccessToken) -> ResultMap in value.resultMap }])
    }

    public var requestAccessToken: RequestAccessToken? {
      get {
        return (resultMap["requestAccessToken"] as? ResultMap).flatMap { RequestAccessToken(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "requestAccessToken")
      }
    }

    public struct RequestAccessToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AccessToken"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("access_token", type: .nonNull(.scalar(String.self))),
          GraphQLField("token_type", type: .nonNull(.scalar(String.self))),
          GraphQLField("expires_in", type: .nonNull(.scalar(Int.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, tokenType: String, expiresIn: Int) {
        self.init(unsafeResultMap: ["__typename": "AccessToken", "access_token": accessToken, "token_type": tokenType, "expires_in": expiresIn])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var accessToken: String {
        get {
          return resultMap["access_token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "access_token")
        }
      }

      public var tokenType: String {
        get {
          return resultMap["token_type"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token_type")
        }
      }

      public var expiresIn: Int {
        get {
          return resultMap["expires_in"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "expires_in")
        }
      }
    }
  }
}
