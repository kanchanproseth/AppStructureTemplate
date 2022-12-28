//
//  NewsCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import UIKit

class NewsCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let viewController = NewsViewController.instantiate()
        
        let services = NewsService()
        let dependencies = NewsViewModelDependencies(
            service: services,
            coordinator: self
        )
        let viewModel = NewsViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        
        
        navigationController.setViewControllers([viewController], animated: true)
        return Observable.empty()
    }
    
    func presentToWebView(_ url: String) {
        let viewController = WebViewController.builder(urlString: url)
        let _navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.present(_navigationController, animated: true, completion: nil)
    }
    
}

