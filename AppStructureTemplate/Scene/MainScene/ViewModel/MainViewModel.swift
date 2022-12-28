//
//  MainViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import RxSwift
import RxCocoa

typealias MainViewModelDependencies = (
    realmManager: RealmManager,
    coordinator: MainCoordinator
)

protocol MainViewModelInputs {
    var viewWillAppearTrigger: PublishSubject<Void> { get }
    var viewDidTapTrigger: PublishRelay<Void> { get }
    var updateDateViewTapTrigger: PublishRelay<Void> { get }
    var relevanceViewTapTrigger: PublishRelay<Void> { get }
}

protocol MainViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishRelay<Error?> { get }
    var sortTypeConfigureView: PublishRelay<SortView.SortType> { get }
}

protocol MainViewModelInterface {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelInterface, MainViewModelOutputs, MainViewModelInputs {
    
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
    
    // MARK: - Intputs
    var viewWillAppearTrigger = PublishSubject<Void>()
    var itemSelectedTrigger = PublishRelay<CardViewItem>()
    var viewDidTapTrigger = PublishRelay<Void>()
    var updateDateViewTapTrigger = PublishRelay<Void>()
    var relevanceViewTapTrigger = PublishRelay<Void>()
    var sortTypeConfigureView = PublishRelay<SortView.SortType>()
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var isError = PublishRelay<Error?>()
    
    private let disposeBag = DisposeBag()
    private var sortType: SortView.SortType? = .updateDate
    
    init(dependencies: MainViewModelDependencies) {
        
        self.checkLocalData(dependencies: dependencies)
        
        updateDateViewTapTrigger
            .do(onNext: {[weak self] _ in
                self?.sortType = .updateDate
            }).map{ _ in dependencies }
            .subscribe(onNext: updateData)
            .disposed(by: disposeBag)
        
        relevanceViewTapTrigger
                .do(onNext: {[weak self] _ in
                    self?.sortType = .updateDate
                }).map{ _ in dependencies }
            .subscribe(onNext: updateData)
            .disposed(by: disposeBag)
    }
}


private extension MainViewModel {
    func checkLocalData(dependencies: MainViewModelDependencies) {
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
            guard let model = data.first as? FilterRealmEntity else { return }
            guard !model.sort.isEmpty else { return }
            guard let type = SortView.SortType(rawValue: model.sort) else { return }
            self.sortType = type
            sortTypeConfigureView.accept(type)
        } else {
            let temp = FilterRealmEntity()
            temp.sort = SortView.SortType.updateDate.rawValue
            dependencies.realmManager.saveObject(temp)
            sortTypeConfigureView.accept(SortView.SortType.updateDate)
        }
    }
    
    func updateData(_ dependencies: MainViewModelDependencies){
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
            guard let model = data.first as? FilterRealmEntity else { return }
            let temp = FilterRealmEntity(value: model)
            temp.sort = sortType?.rawValue ?? ""
            try? dependencies.realmManager.updateObject(temp)
        }
    }
}
