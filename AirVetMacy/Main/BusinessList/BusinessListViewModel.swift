//
//  BusinessListViewModel.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import UIKit
import CoreLocation

protocol BusinessListViewModelDelegate: AnyObject {
    func didSelectBusiness(_ business: YelpBusinessViewModel)
}

enum BusinessFilterType {
    case Distance
    case Rating
}

class BusinessListViewModel: NSObject {

    private static let defaultCategories = "coffee"
    private static let defaultRadiusMeters = 8047 // 5 Miles

    private weak var delegate: BusinessListViewModelDelegate?
    private let api: YelpFusionAPI
    private var locationProvider: LocationProvider
    private var sortHeaderView = SortHeaderView()

    private var businesses = [YelpBusinessViewModel]() {
        didSet {
            filteredBusinesses = businesses
        }
    }

    private var filterType: BusinessFilterType = .Distance {
        didSet {
            sortHeaderView.setSortBy(filterType)
        }
    }

    private var sortDescending: Bool = false {
        didSet {
            sortHeaderView.setSortDescending(sortDescending)
        }
    }

    var filteredBusinesses = [YelpBusinessViewModel]()

    var onApiRequestStarted: (() -> Void)?
    var onApiRequestFinished: (() -> Void)?
    var onBusinessItemsChanged: (() -> Void)?

    init(delegate: BusinessListViewModelDelegate, api: YelpFusionAPI, locationProvider: LocationProvider ) {
        self.delegate = delegate
        self.api = api
        self.locationProvider = locationProvider

        super.init()

        self.locationProvider.delegate = self
        sortHeaderView.delegate = self

        sortHeaderView.setSortDescending(sortDescending)
        sortHeaderView.setSortBy(filterType)
    }

    func onViewAppeared() {
        self.locationProvider.requestLocationUpdates()
    }

    @objc func onRefreshTriggered() {
        performSearch()
    }

    private func filterBusinesses() {
        filteredBusinesses.sort { bus1, bus2 in
            switch filterType {

            case .Distance:
                return bus1.distance > bus2.distance
            case .Rating:
                return bus1.rating > bus2.rating
            }
        }

        if !sortDescending {
            filteredBusinesses.reverse()
        }

        onBusinessItemsChanged?()
    }

    private func performSearch() {
        onApiRequestStarted?()
        guard let location = locationProvider.currentLocation else {
            return
        }

        api.searchBusinesses(latitude: location.coordinate.latitude,
                             longitude: location.coordinate.longitude,
                             radius: BusinessListViewModel.defaultRadiusMeters,
                             categories: BusinessListViewModel.defaultCategories) { [weak self] response in
            DispatchQueue.main.async {
                self?.onApiRequestFinished?()

                guard let response = response else {
                    //TODO: handle api error
                    return
                }

                let viewModels = response.businesses.map({ business in
                    return YelpBusinessViewModel(business: business)
                })
                self?.businesses.removeAll()
                self?.businesses.append(contentsOf: viewModels)
                self?.filterBusinesses()
            }
        }
    }
}

extension BusinessListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let businessVM = filteredBusinesses[indexPath.row]
        cell.textLabel?.text = "\(businessVM.name) \(businessVM.distance) \(businessVM.rating)"

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sortHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
}

extension BusinessListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension BusinessListViewModel: LocationProviderDelegate {
    func locationUpdated() {
        performSearch()
    }

    func locationPermissionChanged(hasPermission: Bool) {

    }
}

extension BusinessListViewModel: SortHeaderViewDelegate {
    func filterPressed() {
        switch filterType {
        case .Distance:
            self.filterType = .Rating
        case .Rating:
            self.filterType = .Distance
        }

        filterBusinesses()
    }

    func sortPressed() {
        sortDescending = !sortDescending

        filterBusinesses()
    }
}
