//
//  HomeViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import RxCocoa

typealias HomePresenterDependencies = (
    service: NewsService,
    coordinator: HomeCoordinator
)

protocol HomePresenterInputs {
    var viewDidLoadTrigger: PublishRelay<Void> { get }
}

protocol HomePresenterOutputs {
    var viewConfigure: PublishRelay<Void> { get }
}

protocol HomePresenterInterface {
    var inputs: HomePresenterInputs { get }
    var outputs: HomePresenterOutputs { get }
}

final class HomeViewModel: HomePresenterInterface, HomePresenterOutputs, HomePresenterInputs {
    
    var inputs: HomePresenterInputs { return self }
    var outputs: HomePresenterOutputs { return self }
    
    // MARK: - Intputs
    var viewDidLoadTrigger = PublishRelay<Void>()
    
    // MARK: - Outputs
    var viewConfigure = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    
    init(dependencies: HomePresenterDependencies) { }
}
