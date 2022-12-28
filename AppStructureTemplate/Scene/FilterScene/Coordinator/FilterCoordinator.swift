//
//  FilterCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import RxSwift
import UIKit

class FilterCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    private var childNavigationController: UINavigationController?
    private let realmManager: RealmManager
    
    init(navigationController: UINavigationController, realmManager: RealmManager) {
        self.navigationController = navigationController
        self.realmManager = realmManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = FilterViewController.instantiate()
        let nav = UINavigationController(rootViewController: viewController)
        let dependencies = FilterViewModelDependencies(
            realmManager: self.realmManager,
            coordinator: self
        )
        let viewModel = FilterViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        self.childNavigationController = nav
        self.navigationController.view.window?.layer.add(CATransition().segueFromRight(), forKey: kCATransition)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController.present(nav, animated: false)
        return Observable.empty()
    }
    
    func dismiss() {
        self.childNavigationController?.view.window?.layer.add(CATransition().popFromLeft(), forKey: kCATransition)
        self.childNavigationController?.dismiss(animated: false, completion: nil)
    }
    
    func moveToSearchType() -> Observable<CoordinationResult>  {
        let searchInCoordinator = SearchInCoordinator(navigationController: self.childNavigationController ?? self.navigationController, realmManager: self.realmManager)
        return  self.coordinate(to: searchInCoordinator)
    }
    
}
