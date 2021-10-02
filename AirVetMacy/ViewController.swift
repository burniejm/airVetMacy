//
//  ViewController.swift
//  AirVetMacy
//
//  Created by John Macy on 10/1/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    let locationService = LocationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationService.addListener(self)
        locationService.getLocation()
    }
}

extension ViewController: LocationChangeListener {
    func locationUpdated(newLocation: CLLocation) {
        let api = YelpFusionAPIService()

        api.searchBusinesses(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, categories: "") { response in
            print(response)
        }
    }
}
