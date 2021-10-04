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
    private let refreshControl = UIRefreshControl()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Businesses"
        controller.automaticallyShowsSearchResultsController = true
        return controller
    }()

    private let titleLabel: UILabel = {
        let yelpString = NSMutableAttributedString.init(string: "")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "yelp_logo")
        attachment.bounds = CGRect(x: 0, y: 0, width: 50, height: 20)
        yelpString.append(NSAttributedString(attachment: attachment))
        yelpString.append(NSAttributedString(string: " Coffee Shops", attributes: [NSAttributedString.Key.baselineOffset : 4]))

        let lbl = UILabel()
        lbl.attributedText = yelpString
        return lbl
    }()

    @IBOutlet private weak var tableViewBusinesses: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleLabel

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

        tableViewBusinesses.addSubview(refreshControl)
        refreshControl.addTarget(viewModel, action: #selector(viewModel.onRefreshTriggered), for: .valueChanged)

        tableViewBusinesses.register(BusinessTableViewCell.self, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier)
    }

    private func setupViewModel() {
        viewModel.onBusinessItemsChanged = { [weak self] in
            self?.tableViewBusinesses.reloadData()
        }

        viewModel.onApiRequestStarted = { [weak self] in
            self?.refreshControl.beginRefreshing()
        }

        viewModel.onApiRequestFinished = { [weak self] in
            self?.refreshControl.endRefreshing()
        }

        viewModel.onApiRequstFailed = { [weak self] in
            self?.showError("Unkown error. Please try again.")
            self?.refreshControl.endRefreshing()
        }

        viewModel.onLocationPermissionDenied = { [weak self] in
            self?.showError("Location permission is not granted. Please open settings and grant permission.")
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
