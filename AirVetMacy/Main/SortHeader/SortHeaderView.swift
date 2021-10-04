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
    func filterPressed()
    func sortPressed()
}

class SortHeaderView: UIView {

    private static let highlightColor = UIColor.init(red: 255, green: 52, blue: 39)

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
        btn.tintColor = highlightColor
        return btn
    }()

    private static let sortTextDistance = NSMutableAttributedString()
        .colorHighlight("Distance", foregroundColor: highlightColor, backgroundColor: UIColor.clear)
        .normal(" / Rating")

    private static let sortTextRating = NSMutableAttributedString()
        .normal("Distance / ")
        .colorHighlight("Rating", foregroundColor: highlightColor, backgroundColor: UIColor.clear)

    @objc private func btnFilterPressed() {
        delegate?.filterPressed()
    }

    @objc private func btnSortPressed() {
        delegate?.sortPressed()
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
        self.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
        addSubViews()
        setupConstraints()

        setSortDescending(true)
        setSortBy(.Distance)
    }

    private func addSubViews() {
        addSubview(lblSort)
        addSubview(btnSortBy)
        addSubview(btnSortDirection)
    }

    private func setupConstraints() {
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
}
