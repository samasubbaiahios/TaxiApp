//
//  TaxiData.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit
import CoreLocation

@objc enum TaxiTypes: Int {
    case normalTaxi = 0
    case poolTaxi
}

@objc class TaxiData: NSObject {
    var carID: Int
    var carType: TaxiTypes
    var distanceAway: Double
    var latitude: Double
    var longitude: Double
    @objc var locationDetail: CLLocation
    
    
    init(fromDict carInfo: [String: Any]) {
        self.carType = TaxiTypes.normalTaxi
        if let fleet = carInfo["fleetType"] as? String {
            if fleet == "POOLING" {
                self.carType = TaxiTypes.poolTaxi
            } else if fleet == "TAXI" {
                self.carType = TaxiTypes.normalTaxi
            }
        }
        self.latitude = 0
        self.longitude = 0
        if let coordinate = carInfo["coordinate"] as? [String: Double] {
            self.latitude = coordinate["latitude"]!
            self.longitude = coordinate["longitude"]!

        }
        self.locationDetail = CLLocation(latitude: self.latitude, longitude: self.longitude)
        self.carID = carInfo["id"] as? Int ?? 0
        self.distanceAway = carInfo["heading"] as! Double
    }

}
