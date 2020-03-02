//
//  TaxiesAPIRequester.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 01/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

class TaxiesAPIRequester {
    
    static var apiClient: NetworkAPIClient?
    
    static func setupClient() {
        apiClient = NetworkAPIClient.create(baseUrl: Constants.urlConstants.kBaseURL)
        NetworkAPIClient.setSharedClient(apiClient)
    }
    /*
     https://fake-poi-api.mytaxi.com/?p1Lon=9.757589&p1Lat=53.694865&p2Lat=53.394655&p2Lon=10.099891
     */
    static func getTaxiesInfo(for coordinates: [String: String], completion: @escaping (ResponseHandler)) {
        var weatherRequest = NetworkRequest(resourcePath: "")
        weatherRequest.shouldIgnoreCacheData = true
        var queryParams = QueryParam()
        for item in coordinates {
            queryParams[item.key] = String(item.value)
        }
        if !queryParams.isEmpty {
            weatherRequest.queryParams = queryParams
        }
        apiClient?.send(request: weatherRequest, completionCallback: completion)
    }
    
}
