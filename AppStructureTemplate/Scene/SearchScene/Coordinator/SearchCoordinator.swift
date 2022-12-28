//
//  SearchCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import UIKit
import RxRelay

class SearchCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: UINavigationController
    private let mainViewController: UIViewController!
    private let realmManager: RealmManager
    
    var searchRelay = PublishRelay<String>()
    var filterRelay = PublishRelay<Void>()
    var showBadger = PublishRelay<(String,Bool)>()
    
    init(mainViewController: UIViewController, navigationController: UINavigationController, realmManager: RealmManager) {
        self.navigationController = navigationController
        self.mainViewController = mainViewController
        self.realmManager = realmManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = SearchViewController.instantiate()
        
        
        let services = NewsService()
        let dependencies = SearchViewModelDependencies(
            realmManager: self.realmManager,
            service: services,
            coordinator: self
        )
        let viewModel = SearchViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        
        navigationController.setViewControllers([viewController], animated: true)
        return Observable.empty()
    }
    
    func moveToFilter() -> Observable<CoordinationResult>  {
        let filterCoordinator = FilterCoordinator(navigationController: self.navigationController, realmManager: self.realmManager)
        return  self.coordinate(to: filterCoordinator)
    }
    
    func presentToWebView(_ url: String) {
        let viewController = WebViewController.builder(urlString: url)
        let _navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.present(_navigationController, animated: true, completion: nil)
        
    }
    
}

