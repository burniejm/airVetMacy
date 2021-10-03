//
//  SortHeader.swift
//  AirVetMacy
//
//  Created by John Macy on 10/2/21.
//

import Foundation
import UIKit
import SnapKit

protocol SortHeaderViewDelegate: AnyObject {
    func btnFilterPressed()
    func btnSortPressed()
}

class SortHeaderView: UIView {

    private let lblSort: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sort:"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()

    private let btnSortBy: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnFilterPressed), for: .touchUpInside)
        return btn
    }()

    private let btnSortDirection: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnSortPressed), for: .touchUpInside)
        return btn
    }()

    private static let sortTextDistance = NSMutableAttributedString().bold("Distance").normal(" / Rating")
    private static let sortTextRating = NSMutableAttributedString().normal("Distance / ").bold("Rating")

    @objc private func btnFilterPressed() {
        delegate?.btnFilterPressed()
    }

    @objc private func btnSortPressed() {
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
        addSubview(lblSort)
        addSubview(btnSortBy)
        addSubview(btnSortDirection)

        lblSort.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalTo(self)
        }

        btnSortBy.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(lblSort.snp.right).offset(5)
            make.centerY.equalTo(self)
        }

        btnSortDirection.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
        }

        setSortDescending(true)
        setSortBy(.Distance)
    }

    func setSortDescending(_ descending: Bool) {
        let buttonImage = descending ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
        btnSortDirection.setImage(buttonImage, for: .normal)
    }

    func setSortBy(_ filterType: BusinessFilterType) {
        switch filterType {

        case .Distance:
            btnSortBy.setAttributedTitle(SortHeaderView.sortTextDistance, for: .normal)
        case .Rating:
            btnSortBy.setAttributedTitle(SortHeaderView.sortTextRating, for: .normal)
        }
    }

    @objc private func lblFilterPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.btnFilterPressed()
    }
}
