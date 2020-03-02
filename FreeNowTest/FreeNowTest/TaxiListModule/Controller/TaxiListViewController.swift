//
//  TaxiListViewController.swift
//  FreeNowTest
//
//  Created by Venkata Subbaiah Sama on 31/07/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class TaxiListViewController: UIViewController {
    
    var carsViewModel: TaxiListViewModel?
    var refControl: UIRefreshControl?

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var carsList: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiStyles()
        navigationBar()
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }

    func uiStyles() {
        addPullToRefresh()
        self.carsList.rowHeight = UITableView.automaticDimension
        self.carsList.estimatedRowHeight = UITableView.automaticDimension
        self.carsList.tableFooterView = UIView()
    }
    func navigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Cabs"
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    func addPullToRefresh() {
        refControl = UIRefreshControl()
        self.carsList.addSubview(refControl!)
        refControl?.addTarget(self, action: (#selector(refreshTasks)), for: .valueChanged)
    }
    
    @objc func refreshTasks() {
        refControl?.endRefreshing()
        getData()
    }
    func updateUI() {
        if carsList.isHidden && UIDevice.isConnectedToNetwork {
            self.getData()
        }
        carsList.isHidden = !UIDevice.isConnectedToNetwork
        networkErrorView.isHidden = UIDevice.isConnectedToNetwork
    }
    func getData() {
        let location = Locations.init(withDefault: ())
        self.carsViewModel?.getCarsInformation(for: location)
    }
    
    @IBAction func changeType(_ sender: Any) {
        self.updateUI()
        self.carsViewModel?.segmentIndex = self.segmentView.selectedSegmentIndex
        self.carsViewModel?.filterTaxies()
    }
}


extension TaxiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let logList = self.carsViewModel?.taxiesLog.value {
            return logList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaxiTableViewCell.kCarCellID) as! TaxiTableViewCell
        if let logList = self.carsViewModel?.taxiesLog.value {
            cell.bind(to: TaxiCellViewModel(locationInfo: logList[indexPath.row]))
        }
        return cell
    }
}

@objc extension TaxiListViewController: Configurable {
    typealias T = TaxiListViewModel
    func bind(to model: TaxiListViewModel) {
        self.carsViewModel = model
        self.carsViewModel?.observe(for: [self.carsViewModel!.taxiesLog], with: { [weak self] (_) in
            DispatchQueue.main.async {
                if let weakSelf = self  {
                    weakSelf.carsList.reloadData()
                    weakSelf.updateUI()
                }
            }
        })
    }
}
