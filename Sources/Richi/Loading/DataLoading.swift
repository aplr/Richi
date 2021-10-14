//
//  DataLoading.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation

public protocol LoadingCancellable: AnyObject {
    func cancel()
}

public protocol DataLoading {
    
    func loadData(
        with request: URLRequest,
        didReceiveData: @escaping (Data, URLResponse) -> Void,
        completion: @escaping (Error?) -> Void
    ) -> LoadingCancellable
    
}

extension URLSessionTask: LoadingCancellable {}
