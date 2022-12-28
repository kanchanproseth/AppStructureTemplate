//
//  SearchInCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import RxSwift
import UIKit

class SearchInCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    private let realmManager: RealmManager
    
    init(navigationController: UINavigationController, realmManager: RealmManager) {
        self.navigationController = navigationController
        self.realmManager = realmManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = SearchInViewController.instantiate()
        let dependencies = SearchInViewModelDependencies(
            realmManager: self.realmManager,
            coordinator: self
        )
        let viewModel = SearchInViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
}

