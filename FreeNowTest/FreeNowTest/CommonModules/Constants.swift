//
//  Constants.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

struct Constants {
    
    struct urlConstants {
        static let kBaseURL = "https://fake-poi-api.mytaxi.com/"
        
    }
    struct locations {
        static let kp1Lat = "53.694865"
        static let kp1Lon = "9.757589"
        static let kp2Lat = "53.394655"
        static let kp2Lon = "10.099891"
    }

}
@objc class LocationConstant: NSObject {
    private override init() {}
    
    class func getFirstLat() -> String { return Constants.locations.kp1Lat }
    class func getFirstLon() -> String { return Constants.locations.kp1Lon }
    class func getSecondLat() -> String { return Constants.locations.kp2Lat }
    class func getSecondLon() -> String { return Constants.locations.kp2Lon }
}
