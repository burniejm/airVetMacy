//
//  MainCoordinator.swift
//  AirVetMacy
//
//  Created by John Macy on 10/1/21.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
}

final class MainCoordinator: Coordinator {

    weak var delegate: MainCoordinatorDelegate?

    var childCoordinators = [Coordinator]()
    var rootViewController: UIViewController? {
        return rootNavController
    }

    private lazy var rootNavController: UINavigationController? = {
        return UIStoryboard.main.instantiateInitialViewController() as? UINavigationController
    }()

    private var businessListViewController: BusinessListViewController {
        let viewController: BusinessListViewController = UIStoryboard.main.getVC()
        viewController.viewModel = BusinessListViewModel(delegate: self, api: YelpFusionAPIService(), locationProvider: LocationService())
        return viewController
    }

    public init(delegate: MainCoordinatorDelegate?) {
        self.delegate = delegate
    }

    func start() {
        restart()
    }

    private func restart() {
        self.rootNavController?.viewControllers = [self.businessListViewController]
    }
}

extension MainCoordinator: BusinessListViewModelDelegate {
    func didSelectBusiness(_ business: YelpBusinessViewModel) {

    }
}
