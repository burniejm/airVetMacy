//
//  BusinessSearchResponse.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation

struct BusinessSearchResponse : Codable {
    let total : Int?
    let businesses : [YelpBusiness]?
    let region : Region?
}
