//
//  BusinessDetailViewModel.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

import Foundation
import UIKit

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
}
