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

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Businesses"
        controller.automaticallyShowsSearchResultsController = true
        return controller
    }()

    @IBOutlet private weak var tableViewBusinesses: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Yelp Coffee Shops"

        setupSearch()
        setupTableView()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeared()
    }

    private func setupSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupTableView() {
        tableViewBusinesses.dataSource = viewModel
        tableViewBusinesses.delegate = viewModel

        tableViewBusinesses.refreshControl = UIRefreshControl()
        tableViewBusinesses.refreshControl?.addTarget(viewModel, action: #selector(viewModel.onRefreshTriggered), for: .valueChanged)

        tableViewBusinesses.register(BusinessTableViewCell.self, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier)
    }

    private func setupViewModel() {
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
}

extension BusinessListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchText = searchController.searchBar.text ?? ""
    }
}

extension BusinessListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.cancelSearchPressed()
    }
}
