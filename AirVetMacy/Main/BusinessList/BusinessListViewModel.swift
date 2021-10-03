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

enum BusinessSortType {
    case Distance
    case Rating
}

class BusinessListViewModel: NSObject {

    private static let defaultCategories = "coffee"
    private static let defaultRadiusMeters = 8047

    private weak var delegate: BusinessListViewModelDelegate?
    private let api: YelpFusionAPI
    private var locationProvider: LocationProvider

    private var businesses = [YelpBusinessViewModel]() {
        didSet {
            filteredBusinesses = businesses
        }
    }

    var filteredBusinesses = [YelpBusinessViewModel]() {
        didSet {
            onBusinessItemsChanged?()
        }
    }

    var onApiRequestStarted: (() -> Void)?
    var onApiRequestFinished: (() -> Void)?
    var onBusinessItemsChanged: (() -> Void)?

    init(delegate: BusinessListViewModelDelegate, api: YelpFusionAPI, locationProvider: LocationProvider ) {
        self.delegate = delegate
        self.api = api
        self.locationProvider = locationProvider

        super.init()

        self.locationProvider.delegate = self
    }

    func onViewAppeared() {
        self.locationProvider.requestLocationUpdates()
    }

    @objc func onRefreshTriggered() {
        performSearch()
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
        let businessVM = businesses[indexPath.row]
        cell.textLabel?.text = businessVM.business.name

        return cell
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
