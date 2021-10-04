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

struct BusinessTableViewCellSettings {
    static func preferredHeight() -> CGFloat {
        return BusinessTableViewCellSettings.imageHeight + (2 * standardViewOffset)
    }

    static let largeTextSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 14.0 : 24.0
    static let smallTextSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 12.0 : 18.0

    static let imageHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 60 : 120
    static let imageWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 80 : 160

    static let starSize: Double = UIDevice.current.userInterfaceIdiom == .phone ? 15 : 20
    static let starMargin: Double = UIDevice.current.userInterfaceIdiom == .phone ? 0 : 5

    static let standardViewOffset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 5.0 : 10.0
    static let cornerRadius: CGFloat = 12
}

class BusinessTableViewCell: UITableViewCell {

    static let reuseIdentifier = "BusinessTableViewCell"

    private let lblName: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.font = UIFont.boldSystemFont(ofSize: BusinessTableViewCellSettings.largeTextSize)
        return view
    }()

    private let imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = BusinessTableViewCellSettings.cornerRadius
        view.layer.masksToBounds = true
        view.sd_imageTransition = .fade
        view.image = UIImage(named: "yelp_logo")
        return view
    }()

    private let lblOpenStatus: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: BusinessTableViewCellSettings.smallTextSize)
        return view
    }()

    private let lblPrice: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: BusinessTableViewCellSettings.smallTextSize)
        return view
    }()

    private let lblDistance: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = UIFont.systemFont(ofSize: BusinessTableViewCellSettings.smallTextSize)
        return view
    }()

    private let ratingView: CosmosView = {
        let view = CosmosView()

        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        view.settings.updateOnTouch = false
        view.settings.starSize = BusinessTableViewCellSettings.starSize
        view.settings.starMargin = BusinessTableViewCellSettings.starMargin
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

        accessoryType = .disclosureIndicator
    }

    private func addSubviews() {
        self.contentView.addSubview(lblName)
        self.contentView.addSubview(lblPrice)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(lblOpenStatus)
        self.contentView.addSubview(lblDistance)
        self.contentView.addSubview(ratingView)
    }

    private func setupConstraints() {

        imgView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(BusinessTableViewCellSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessTableViewCellSettings.standardViewOffset)
            make.height.equalTo(BusinessTableViewCellSettings.imageHeight)
            make.width.equalTo(BusinessTableViewCellSettings.imageWidth)
        }

        lblName.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(BusinessTableViewCellSettings.standardViewOffset)
            make.right.equalTo(ratingView.snp.left).offset(-BusinessTableViewCellSettings.standardViewOffset)

            make.left.equalTo(imgView.snp.right).offset(BusinessTableViewCellSettings.standardViewOffset)
        }

        ratingView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(BusinessTableViewCellSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }

        lblPrice.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }

        lblOpenStatus.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
            make.left.equalTo(imgView.snp.right).offset(BusinessTableViewCellSettings.standardViewOffset)
        }

        lblDistance.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }
    }

    override func prepareForReuse() {
        lblName.text = nil
        lblPrice.text = nil
        imgView.image = nil
        imgView.contentMode = .scaleAspectFill
        lblOpenStatus.text = nil
        lblDistance.text = nil
        ratingView.rating = 0
    }

    func configure(viewModel: YelpBusinessViewModel) {
        lblName.text = viewModel.name
        lblPrice.text = viewModel.price
        lblDistance.text = viewModel.distanceDisplay(type: .miles)
        lblOpenStatus.text = viewModel.openStatus
        ratingView.rating = viewModel.rating

        if let validURL = viewModel.imgURL {
            imgView.sd_setImage(with: validURL)
        } else {
            imgView.contentMode = .scaleAspectFit
            imgView.image = UIImage(named: "yelp_logo")
        }
    }
}
