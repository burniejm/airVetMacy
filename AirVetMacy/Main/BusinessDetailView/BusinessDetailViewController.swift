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

    static let standardViewOffset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 5.0 : 10.0

    static let mapHeight: CGFloat = 200.0
}

class BusinessDetailViewController: UIViewController {

    var viewModel: BusinessDetailViewModel!

    private let lblName: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: BusinessDetailViewSettings.largeTextSize)
        return view
    }()

    private let imgView: UIImageView = {
        let view = UIImageView()
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

    private let lblWebsite: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: BusinessDetailViewSettings.smallTextSize)
        return view
    }()

    private let btnPhone: UIButton = {
        let view = UIButton()

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
        view.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 4000), animated: false)
        view.layer.cornerRadius = 12
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        addSubviews()
        setupConstraints()
        configure()
    }

    private func addSubviews() {
        self.view.addSubview(lblName)
        self.view.addSubview(imgView)
        self.view.addSubview(lblOpenStatus)
        self.view.addSubview(lblDistance)
        self.view.addSubview(lblWebsite)
        self.view.addSubview(btnPhone)
        self.view.addSubview(ratingView)
        self.view.addSubview(mapView)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
            make.height.equalTo(BusinessDetailViewSettings.mapHeight)
        }

        lblName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mapView.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.left.equalToSuperview().offset(BusinessDetailViewSettings.standardViewOffset)
        }

        ratingView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(mapView.snp.bottom).offset(BusinessDetailViewSettings.standardViewOffset)
            make.right.equalToSuperview().offset(-BusinessTableViewCellSettings.standardViewOffset)
        }
    }

    private func configure() {
        lblName.text = viewModel.yelpBusiness.name
        lblDistance.text = viewModel.yelpBusiness.distanceDisplay(type: .miles)
        lblOpenStatus.text = viewModel.yelpBusiness.openStatus
        ratingView.rating = viewModel.yelpBusiness.rating
        lblWebsite.text = viewModel.yelpBusiness.website
        btnPhone.setTitle(viewModel.yelpBusiness.phoneNumber, for: .normal)

        if let validURL = viewModel.yelpBusiness.imgURL {
            imgView.sd_setImage(with: validURL)
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
        print("here")
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
