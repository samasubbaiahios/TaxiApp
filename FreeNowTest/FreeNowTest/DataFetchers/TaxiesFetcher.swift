//
//  TaxiesFetcher.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 01/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

@objc class TaxiesFetcher: NSObject {
    
    override init() {
        super.init()
    }
    
    @objc func getTaxiesInfo(location: Locations, completion: @escaping (finishedHandler)) {
        let locationsInfo = ["p1Lat": location.firstLatitude,
                             "p1Lon": location.firstLongitude,
                             "p2Lat": location.secondLatitude,
                             "p2Lon": location.secondLongitude]
        TaxiesAPIRequester.setupClient()
        TaxiesAPIRequester.getTaxiesInfo(for: locationsInfo ) { apiResponse in
            if let jsonRes = apiResponse.asJSON() {
                var carsData = [TaxiData]()
                if let positions = jsonRes["poiList"] as? [[String: Any]] {
                    for car in positions {
                        let carInfo = TaxiData.init(fromDict: car)
                        carsData.append(carInfo)
                    }
                }
                carsData.sort(by: {$0.distanceAway < $1.distanceAway})
                completion(true, carsData)
            } else {
                completion(false, [])
            }
        }
    }
}
