//
//  MainCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import UIKit

class MainCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let viewControllers: [UINavigationController]
    
    init(window: UIWindow) {
        self.window = window
        self.viewControllers = MainTabBarEntity.items
            .map({ (items) -> UINavigationController in
                let navigation = UINavigationController()
                navigation.tabBarItem.title = items.title
                navigation.tabBarItem.image = items.icon
                return navigation
            })
    }
    
    override func start() -> Observable<CoordinationResult> {
        let realmManager = RealmManager()
        let dependencies = MainViewModelDependencies(
            realmManager: realmManager,
            coordinator: self
        )
        let viewModel = MainViewModel(dependencies: dependencies)
        let mainViewController = MainViewController.instantiate()
        mainViewController.viewModel = viewModel
        mainViewController.tabBar.isTranslucent = false
        mainViewController.viewControllers = viewControllers
        
        
        
        
        let coordinates = viewControllers.enumerated()
            .map { (offset, element) -> Observable<Void> in
                guard let items = MainTabBarEntity(rawValue: offset) else { return Observable.just(() )}
                switch items {
                case .home:
                    return coordinate(to: HomeCoordinator(navigationController: element))
                case .news:
                    return coordinate(to: NewsCoordinator(navigationController: element))
                case .search:
                    let searchCoordinator = SearchCoordinator(mainViewController: mainViewController, navigationController: element, realmManager: realmManager)
                    
                    searchCoordinator.showBadger
                        .bind(to: mainViewController.showBadger)
                        .disposed(by: disposeBag)
                    
                    mainViewController.searchRelay
                        .bind(to: searchCoordinator.searchRelay)
                        .disposed(by: disposeBag)
                    
                    mainViewController.filterRelay
                        .bind(to: searchCoordinator.filterRelay)
                        .disposed(by: disposeBag)
                    
                    return coordinate(to: searchCoordinator)
                case .profile:
                    return coordinate(to: ProfileCoordinator(navigationController: element))
                case .more:
                    return coordinate(to: MoreCoordinator(navigationController: element))
                }
        }
        
        Observable.merge(coordinates)
            .subscribe()
            .disposed(by: disposeBag)
        
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        return Observable.never()
    }
}
