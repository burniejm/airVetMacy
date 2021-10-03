//
//  SortHeader.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import UIKit

protocol SortHeaderViewDelegate: AnyObject {
    func btnFilterPressed()
    func btnSortPressed()
}

class SortHeaderView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var btnFilter: UIButton!
    @IBOutlet private weak var btnSort: UIButton!

    @IBAction private func btnFilterPressed(_ sender: Any) {
        delegate?.btnFilterPressed()
    }

    @IBAction private func btnSortPressed(_ sender: Any) {
        delegate?.btnSortPressed()
    }

    weak var delegate: SortHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: SortHeaderView.self), owner: self)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setSortDescending(_ descending: Bool) {
        let buttonImage = descending ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        btnSort.setImage(buttonImage, for: .normal)
    }

    func setFilterType(_ filterType: BusinessFilterType) {
        switch filterType {

        case .Distance:
            btnFilter.setTitle("'Distance' / Rating", for: .normal)
        case .Rating:
            btnFilter.setTitle("Distance / 'Rating'", for: .normal)
        }
    }

    @objc private func lblFilterPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.btnFilterPressed()
    }

}
