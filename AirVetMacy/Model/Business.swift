//
//  Business.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation

struct YelpBusiness : Codable {
    let rating : Float?
    let price : String?
    let phone : String?
    let id : String?
    let alias : String?
    let is_closed : Bool?
    let categories : [YelpCategory]?
    let review_count : Int?
    let name : String?
    let url : String?
    let coordinates : Coordinates?
    let image_url : String?
    let location : Location?
    let distance : Double?
    let transactions : [String]?
}

enum DistanceDisplayType {
    case meters
    case miles
}

struct YelpBusinessViewModel {
    static let metersInAMile = 1609.34

    let business: YelpBusiness

    var name: String {
        business.name ?? "Name Unknown"
    }

    var nameWithPrice: String {
        if !price.isEmpty {
            return "\(name) (\(price))"
        } else {
            return name
        }
    }

    var phoneNumber: String {
        business.phone ?? ""
    }

    var price: String {
        business.price ?? ""
    }

    var webURL: URL? {
        guard let url = business.url else {
            return nil
        }

        return URL(string: url)
    }

    var rating: Double {
        Double(business.rating ?? 0)
    }

    var distance: Double {
        business.distance ?? 0
    }

    func distanceDisplay(type: DistanceDisplayType) -> String {
        guard let distance = business.distance else {
            return "0.00"
        }

        switch type {
        case .miles:
            let miles = distance / YelpBusinessViewModel.metersInAMile
            return String(format: "%.01f miles", miles)

        case .meters:
            return String(format: "%.01f meters", distance)
        }
    }

    var openStatus: String {
        guard let closed = business.is_closed else {
            return "?"
        }

        return closed ? "Closed" : "Open"
    }

    var imgURL: URL? {
        guard let imageUrl = business.image_url else {
            return nil
        }

        return URL(string: imageUrl)
    }

    var latitude: Double {
        business.coordinates?.latitude ?? 0
    }

    var longitude: Double {
        business.coordinates?.longitude ?? 0
    }
}
