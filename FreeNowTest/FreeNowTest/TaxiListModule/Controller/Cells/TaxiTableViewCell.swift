//
//  TaxiTableViewCell.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 03/08/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class TaxiTableViewCell: UITableViewCell {
    static let kCarCellID = "taxiCell"

    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var taxiAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var viewModel: TaxiCellViewModel? {
        didSet {
            let carModel: TaxiData = viewModel?.getList() ?? TaxiData.init(fromDict: [:])
           
            let doubleStr = String(format: "%.2f", carModel.distanceAway)
            //hard coding the parameters
            let distanceAway = doubleStr + " " + "meters Away"
            self.distanceLabel.text = distanceAway
            self.distanceLabel.font = UIFont.systemFont(ofSize: 14)
            self.distanceLabel.textColor = UIColor.lightGray
            
            if carModel.carType == .normalTaxi {
                self.taxiAvatar.image = UIImage(named: "Taxi")
                self.carName.text = "Hire Taxi"
            } else if carModel.carType == .poolTaxi {
                self.taxiAvatar.image = UIImage(named: "Pool")
                self.carName.text = "Pool Taxi"
            }
            self.carName.font = UIFont.systemFont(ofSize: 16)
            self.carName.textColor = UIColor.black
        }
    }
    
}
@objc extension TaxiTableViewCell: Configurable {
    typealias T = TaxiCellViewModel
    func bind(to model: TaxiCellViewModel) {
        self.viewModel = model
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
