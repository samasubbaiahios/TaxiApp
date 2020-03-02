//
//  TaxiCellViewModel.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 03/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class TaxiCellViewModel: NSObject {
    var taxies : TaxiData
    init(locationInfo: TaxiData) {
        self.taxies = locationInfo
    }
    func getList() -> TaxiData {
        return taxies
    }
}
