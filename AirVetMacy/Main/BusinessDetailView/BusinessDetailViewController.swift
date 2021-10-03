//
//  BusinessDetailViewController.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

import Foundation
import UIKit
import SnapKit
import Cosmos
import SDWebImage
import MapKit

struct BusinessDetailViewSettings {
    static let largeTextSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 18.0 : 24.0
    static let smallTextSize: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 14.0 : 18.0

    static let imageHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 60 : 120
    static let imageWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 80 : 160

    static let starSize: Double = UIDevice.current.userInterfaceIdiom == .phone ? 15 : 20
    static let starMargin: Double = UIDevice.current.userInterfaceIdiom == .phone ? 0 : 5

    static let standardViewOffset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 10.0 : 20.0

    static let mapHeight: CGFloat = 200.0
    static let maxMapZoomMeters: CLLocationDistance = 4000
    static let cornerRadius: CGFloat = 12
}

class BusinessDetailViewController: UIViewController {

    static let phoneCallsUnsupportedMessage = "Sorry, phone calls are not supported on this device."

    var viewModel: BusinessDetailViewModel!

    private let lblName: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: BusinessDetailViewSettings.largeTextSize)
        return view
    }()

    private let imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = BusinessDetailViewSettings.cornerRadius
        view.layer.masksToBounds = true
        view.sd_imageTransition = .fade
        return view
    }()

    private let lblOpenStatus: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: BusinessDetailViewSettings.smallTextSize)
        return view
    }()

    private let lblDistance: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = UIFont.systemFont(ofSize: BusinessDetailViewSettings.smallTextSize)
        return view
    }()

    private let btnWebsite: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.setTitleColor(.blue, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: BusinessDetailViewSettings.smallTextSize)
        view.addTarget(self, action: #selector(websitePressed), for: .touchUpInside)
        return view
    }()

    private let btnPhone: UIButton = {
        let view = UIButton(type: .system)
        view.setTitleColor(.blue, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: BusinessDetailViewSettings.smallTextSize)
        view.addTarget(self, action: #selector(phonePressed), for: .touchUpInside)
        return view
    }()

    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.starSize = BusinessDetailViewSettings.starSize
        view.settings.starMargin = BusinessDetailViewSettings.starMargin
        return view
    }()

    private let mapView: MKMapView = {
        let view = MKMapView()
        view.isScrollEnabled = false
        view.isZoomEnabled = false
        view.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: BusinessDetailViewSettings.maxMapZoomMeters), animated: false)
        view.layer.cornerRadius = 12
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        addSubviews()
        setupConstraints()
        configure()

        viewModel.onCallUnsupported = { [weak self] in
            self?.showError(BusinessDetailViewController.phoneCallsUnsupportedMessage)
        }
    }

    private func addSubviews() {
        self.view.addSubview(lblName)
        self.view.addSubview(imgView)
        self.view.addSubview(lblOpenStatus)
        self.view.addSubview(lblDistance)
        self.view.addSubview(btnWebsite)
        self.view.addSubview(btnPhone)
        self.view.addSubview(ratingView)
        self.view.addSubview(mapView)
    }

    private func setupConstraints() {
        imgView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
            make.height.equalTo(BusinessDetailViewSettings.mapHeight)
        }

        lblName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imgView.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
        }

        ratingView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imgView.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }

        lblOpenStatus.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lblName.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
        }

        lblDistance.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lblName.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }

        btnWebsite.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lblOpenStatus.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
        }

        btnPhone.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lblOpenStatus.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }

        mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(btnWebsite.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
            make.height.equalTo(BusinessDetailViewSettings.mapHeight)
        }
    }

    private func configure() {
        lblName.text = viewModel.yelpBusiness.nameWithPrice
        lblDistance.text = viewModel.yelpBusiness.distanceDisplay(type: .miles)
        lblOpenStatus.text = viewModel.yelpBusiness.openStatus
        ratingView.rating = viewModel.yelpBusiness.rating

        if viewModel.yelpBusiness.webURL != nil {
            btnWebsite.setTitle("View on Yelp", for: .normal)
        } else {
            btnWebsite.isHidden = true
        }

        let phoneText = viewModel.yelpBusiness.phoneNumber.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
        btnPhone.setTitle(phoneText, for: .normal)

        if let validImgURL = viewModel.yelpBusiness.imgURL {
            imgView.sd_setImage(with: validImgURL)
        }

        mapView.delegate = self
        let coordinate = CLLocationCoordinate2D(latitude: viewModel.yelpBusiness.latitude, longitude: viewModel.yelpBusiness.longitude)
        mapView.setCenter(coordinate, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = viewModel.yelpBusiness.name
        mapView.addAnnotation(annotation)
    }

    @objc private func annotationButtonPressed() {

    }

    @objc private func phonePressed() {
        viewModel.callPhone()
    }

    @objc private func websitePressed() {
        viewModel.openWebsite()
    }
}

extension BusinessDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"annotation")
        annotationView.isEnabled = true
        annotationView.canShowCallout = true

        let btn = UIButton(type: .infoDark)
        btn.addTarget(self, action: #selector(annotationButtonPressed), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = btn
        return annotationView
    }
}
