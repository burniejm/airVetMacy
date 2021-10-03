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

struct YelpBusinessViewModel {
    let business: YelpBusiness
}
