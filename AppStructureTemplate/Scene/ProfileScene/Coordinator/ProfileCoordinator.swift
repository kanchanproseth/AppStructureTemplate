//
//  ProfileCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//


import RxSwift
import UIKit

class ProfileCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewController = ProfileViewController.instantiate()
        navigationController.setViewControllers([viewController], animated: true)
        return Observable.empty()
    }
    
}


