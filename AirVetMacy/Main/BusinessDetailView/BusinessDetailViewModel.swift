//
//  BusinessDetailViewModel.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

import Foundation
import UIKit
import MapKit

protocol BusinessDetailViewModelDelegate: AnyObject {

}

class BusinessDetailViewModel {

    private weak var delegate: BusinessDetailViewModelDelegate?
    private(set) var yelpBusiness: YelpBusinessViewModel!

    var onCallUnsupported: (() -> Void)?

    init(delegate: BusinessDetailViewModelDelegate?, businessViewModel: YelpBusinessViewModel) {
        self.delegate = delegate
        self.yelpBusiness = businessViewModel
    }

    func callPhone() {
        if let url = URL(string: "tel://\(yelpBusiness.phoneNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                onCallUnsupported?()
            }
        }
    }

    func openWebsite() {
        guard let validUrl = yelpBusiness.webURL else { return }
        UIApplication.shared.open(validUrl)
    }

    func openMaps() {
        let latitude: CLLocationDegrees = yelpBusiness.latitude
        let longitude: CLLocationDegrees = yelpBusiness.longitude
        let regionDistance:CLLocationDistance = BusinessDetailViewSettings.maxMapZoomMeters
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = yelpBusiness.name
        mapItem.openInMaps(launchOptions: options)
    }
}
