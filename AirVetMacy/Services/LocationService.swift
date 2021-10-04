//
//  LocationService.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import CoreLocation

protocol LocationProvider {
    var delegate: LocationProviderDelegate? { get set }
    var currentLocation: CLLocation? { get }
    func requestLocationUpdates()
    func stopLocationUpdates()
}

protocol LocationProviderDelegate: AnyObject {
    func locationUpdated()
    func locationPermissionChanged(hasPermission: Bool)
}

class LocationService: NSObject {

    weak var delegate: LocationProviderDelegate?
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
    }
}

extension LocationService: LocationProvider {
    func requestLocationUpdates() {
        locationManager.requestWhenInUseAuthorization()

        switch locationManager.authorizationStatus {

        case .notDetermined, .restricted, .denied:
            delegate?.locationPermissionChanged(hasPermission: false)
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationPermissionChanged(hasPermission: true)
        @unknown default:
            break
        }

        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations.first
            delegate?.locationUpdated()
            stopLocationUpdates()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {

        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationPermissionChanged(hasPermission: true)
        case .notDetermined, .restricted, .denied:
            delegate?.locationPermissionChanged(hasPermission: false)
        @unknown default:
            delegate?.locationPermissionChanged(hasPermission: false)
        }
    }
}
