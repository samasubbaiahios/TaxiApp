//
//  InputLocations.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 03/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

class InputLocations: NSObject {
    
    public var firstLatitude: String?
    public var firstLongitude: String?
    public var secondLatitude: String?
    public var secondLongitude: String?

    // MARK: - designated initializer
    init(firstLat: String, firstLon: String, secondLat: String, secondLon: String) {
        self.firstLatitude = firstLat
        self.firstLongitude = firstLon
        self.secondLatitude = secondLat
        self.secondLongitude = secondLon
    }
    
    // MARK: - convenience initializer
    convenience override init() {
        self.init(firstLat: Constants.locations.kp1Lat, firstLon: Constants.locations.kp1Lon, secondLat: Constants.locations.kp2Lat, secondLon: Constants.locations.kp2Lon)
    }
}
