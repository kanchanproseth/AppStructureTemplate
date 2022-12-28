//
//  AppCoordinator.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = UIColor.white
    }
    
    override func start() -> Observable<CoordinationResult> {
        let mainCoordinator = MainCoordinator(window: window)
        return self.coordinate(to: mainCoordinator)
    }
}
