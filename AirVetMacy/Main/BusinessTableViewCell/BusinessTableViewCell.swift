//
//  BusinessTableViewCell.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

import Foundation
import UIKit
import SnapKit
import Cosmos
import SDWebImage

class BusinessTableViewCell: UITableViewCell {

    static let reuseIdentifier = "BusinessTableViewCell"
    static let preferredHeight: CGFloat = 70.0

    static let largeTextSize: CGFloat = 14.0
    static let smallTextSize: CGFloat = 12.0

    static let imageWidth = 80
    static let imageHeight = 60

    private let lblName: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: largeTextSize)
        return view
    }()

    private let imgView: UIImageView = {
        let view = UIImageView()
        view.sd_imageTransition = .fade
        return view
    }()

    private let lblOpenStatus: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: smallTextSize)
        return view
    }()

    private let lblDistance: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = UIFont.systemFont(ofSize: smallTextSize)
        return view
    }()

    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.starSize = 15
        view.settings.starMargin = 2
        return view
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    private func commonInit() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        self.contentView.addSubview(lblName)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(lblOpenStatus)
        self.contentView.addSubview(lblDistance)
        self.contentView.addSubview(ratingView)
    }

    private func setupConstraints() {
        let standardOffset = 5

        imgView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(standardOffset)
            make.left.equalToSuperview().offset(standardOffset)
            make.height.equalTo(BusinessTableViewCell.imageHeight)
            make.width.equalTo(BusinessTableViewCell.imageWidth)
        }

        lblName.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(standardOffset)
            make.right.equalTo(ratingView.snp.left).offset(-standardOffset)
            make.left.equalTo(imgView.snp.right).offset(standardOffset)
        }

        ratingView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(standardOffset)
            make.right.equalToSuperview().offset(-standardOffset)
        }

        lblOpenStatus.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(-standardOffset)
            make.left.equalTo(imgView.snp.right).offset(standardOffset)
        }

        lblDistance.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(-standardOffset)
            make.right.equalToSuperview().offset(-standardOffset)
        }
    }

    override func prepareForReuse() {
        lblName.text = ""
        imgView.image = nil
        lblOpenStatus.text = ""
        lblDistance.text = ""
        ratingView.rating = 0
    }

    func configure(viewModel: YelpBusinessViewModel) {
        lblName.text = viewModel.name
        lblDistance.text = viewModel.distanceDisplay(type: .miles)
        lblOpenStatus.text = viewModel.openStatus
        ratingView.rating = viewModel.rating

        if let validURL = viewModel.imgURL {
            imgView.sd_setImage(with: validURL)
        }
    }
}
