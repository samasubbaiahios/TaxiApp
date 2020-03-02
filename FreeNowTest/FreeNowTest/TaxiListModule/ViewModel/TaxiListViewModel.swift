//
//  TaxiListViewModel.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class TaxiListViewModel: NSObject {

    var taxiesLog: Observable<[TaxiData]> = Observable()
    var segmentIndex = 0
    var showError: Bool?
    var orignalTaxiesLog: [TaxiData]?

    override init() {
        super.init()
    }
    
    func getCarsInformation(for location: Locations) {
        let apiCaller = TaxiesFetcher.init()
        apiCaller.getTaxiesInfo(location: location) {(isDone, taxiData) in
            if isDone {
                self.orignalTaxiesLog = taxiData
                self.filterTaxies()
            }
            self.showError = !isDone
        }
    }

    func filterTaxies() {

        switch segmentIndex {
        case 0:
            self.taxiesLog.value = self.orignalTaxiesLog?.filter({ $0.carType == TaxiTypes.poolTaxi })
        case 1:
            self.taxiesLog.value = self.orignalTaxiesLog?.filter({ $0.carType == TaxiTypes.normalTaxi})
        default:
            self.taxiesLog.value = self.orignalTaxiesLog
        }
        
    }
}
