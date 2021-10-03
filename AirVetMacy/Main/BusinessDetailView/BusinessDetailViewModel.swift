//
//  BusinessDetailViewModel.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

import Foundation

protocol BusinessDetailViewModelDelegate: AnyObject {

}

class BusinessDetailViewModel {

    private weak var delegate: BusinessDetailViewModelDelegate?
    private(set) var yelpBusiness: YelpBusinessViewModel!

    init(delegate: BusinessDetailViewModelDelegate?, businessViewModel: YelpBusinessViewModel) {
        self.delegate = delegate
        self.yelpBusiness = businessViewModel
    }

}
