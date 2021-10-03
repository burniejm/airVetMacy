//
//  BusinessListViewController.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import UIKit

class BusinessListViewController: UIViewController {

    var viewModel: BusinessListViewModel!

    @IBOutlet private weak var tableViewBusinesses: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        viewModel.onBusinessItemsChanged = { [weak self] in
            self?.tableViewBusinesses.reloadData()
        }

        viewModel.onApiRequestStarted = { [weak self] in
            self?.tableViewBusinesses.refreshControl?.beginRefreshing()
        }

        viewModel.onApiRequestFinished = { [weak self] in
            self?.tableViewBusinesses.refreshControl?.endRefreshing()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeared()
    }

    private func setupTableView() {
        tableViewBusinesses.dataSource = viewModel
        tableViewBusinesses.delegate = viewModel

        tableViewBusinesses.refreshControl = UIRefreshControl()
        tableViewBusinesses.refreshControl?.addTarget(viewModel, action: #selector(viewModel.onRefreshTriggered), for: .valueChanged)

        tableViewBusinesses.register(BusinessTableViewCell.self, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier)
    }
}
