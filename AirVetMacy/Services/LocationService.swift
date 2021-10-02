//
//  LocationService.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import CoreLocation

protocol LocationChangeListener: AnyObject {
    func locationUpdated(newLocation: CLLocation)
}

class LocationService: NSObject {

    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    private var locationListeners = [LocationChangeListener]()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func addListener(_ listener: LocationChangeListener) {
        locationListeners.append(listener)
    }

    func removeListener(_ listener: LocationChangeListener) {
        if let index = locationListeners.firstIndex(where: { l in
            return l === listener
        }) {
            locationListeners.remove(at: index)
        }
    }

    private func notifiyListeners() {
        guard let currentLocation = currentLocation else { return }

        for listener in locationListeners {
            listener.locationUpdated(newLocation: currentLocation)
        }
    }

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            notifiyListeners()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {

        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
}
