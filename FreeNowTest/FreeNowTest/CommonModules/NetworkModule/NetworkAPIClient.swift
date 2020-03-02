//
//  NetworkAPIClient.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

class NetworkAPIClient {
    
    var baseUrl: String
    
    private static var sharedClient: NetworkAPIClient?
    
    private init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    static func create(baseUrl: String) -> NetworkAPIClient {
        let client = NetworkAPIClient(baseUrl: baseUrl)
        return client
    }
    
    public static func shared() -> NetworkAPIClient? {
        if sharedClient != nil {
            return sharedClient
        }
        
        return nil
    }
    
    public static func setSharedClient(_ client: NetworkAPIClient?) {
        sharedClient = client
    }
    
    public var baseURL: URL? {
        return URL(string: baseUrl)
    }
    
    func send(request: RequestProtocol, completionCallback: @escaping (ResponseHandler)) {
        NetworkManager.shared().startLoading(request: request, with: completionCallback)
    }
}
