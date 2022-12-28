//
//  FilterViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import RxSwift
import RxCocoa

typealias FilterViewModelDependencies = (
    realmManager: RealmManager,
    coordinator: FilterCoordinator
)

protocol FilterViewModelInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var viewWillAppearTrigger: PublishSubject<Void> { get }
    var clearTrigger: PublishRelay<Void> { get }
    var backTrigger: PublishRelay<Void> { get }
    var searchTypeTapTrigger: PublishRelay<Void> { get }
    var fromDateTrigger: PublishRelay<String> { get }
    var toDateTrigger: PublishRelay<String> { get }
    var applyTrigger: PublishRelay<Void> { get }
}

protocol FilterViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishRelay<Error?> { get }
    var isCear: PublishRelay<Void> { get }
    var fromDate: PublishRelay<String> { get }
    var toDate: PublishRelay<String> { get }
    var searchBy: PublishRelay<String> { get }
}

protocol FilterViewModelInterface {
    var inputs: FilterViewModelInputs { get }
    var outputs: FilterViewModelOutputs { get }
}

final class FilterViewModel: FilterViewModelInterface, FilterViewModelOutputs, FilterViewModelInputs {
    
    var inputs: FilterViewModelInputs { return self }
    var outputs: FilterViewModelOutputs { return self }
    
    // MARK: - Intputs
    var viewDidLoadTrigger = PublishSubject<Void>()
    var viewWillAppearTrigger = PublishSubject<Void>()
    var clearTrigger = PublishRelay<Void>()
    var backTrigger = PublishRelay<Void>()
    var searchTypeTapTrigger = PublishRelay<Void>()
    var fromDateTrigger = PublishRelay<String>()
    var toDateTrigger = PublishRelay<String>()
    var applyTrigger = PublishRelay<Void>()
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var isError = PublishRelay<Error?>()
    var isCear = PublishRelay<Void>()
    var fromDate = PublishRelay<String>()
    var toDate = PublishRelay<String>()
    var searchBy = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    private var from = ""
    private var to = ""
    
    
    
    init(dependencies: FilterViewModelDependencies) {
        
        viewDidLoadTrigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.checkFilterLocalData(dependencies: dependencies)
        }).disposed(by: disposeBag)
        
        viewWillAppearTrigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.checkFilterLocalData(dependencies: dependencies)
        }).disposed(by: disposeBag)
        
        fromDateTrigger.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            self.from = value
        }).disposed(by: disposeBag)
        
        toDateTrigger.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            self.to = value
        }).disposed(by: disposeBag)
        
        applyTrigger
            .do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.apply(dependencies: dependencies)
            })
            .subscribe(onNext: {
                let _ = dependencies.coordinator.dismiss()
        }).disposed(by: disposeBag)
        
        backTrigger
            .subscribe(onNext: {
                let _ = dependencies.coordinator.dismiss()
            })
            .disposed(by: disposeBag)
        
        clearTrigger
            .do(onNext: {
                self.from = ""
                self.to = ""
            })
            .bind(to: isCear)
            .disposed(by: disposeBag)
        
        searchTypeTapTrigger
            .subscribe(onNext: {
                let _ = dependencies.coordinator.moveToSearchType()
            })
            .disposed(by: disposeBag)
    }
    
}

extension FilterViewModel {
    func checkFilterLocalData(dependencies: FilterViewModelDependencies) {
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
            guard let model = data.first as? FilterRealmEntity else { return }
            self.fromDate.accept(model.from)
            self.toDate.accept(model.to)
            self.to = model.to
            self.from = model.from
            
            var searchBy = [String]()
            if (model.searchByTitle == true) { searchBy.append("title")}
            if (model.searchByDescription == true) { searchBy.append("description")}
            if (model.searchByContent == true) { searchBy.append("content")}
            
            if searchBy.count == 3 {
                self.searchBy.accept("All")
            } else {
                self.searchBy.accept(searchBy.joined(separator: ", "))
            }
        }
    }
    
    func apply(dependencies: FilterViewModelDependencies) {
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
            guard let model = data.first as? FilterRealmEntity else { return }
            let temp = FilterRealmEntity(value: model)
            temp.from = self.from
            temp.to = self.to
            try? dependencies.realmManager.updateObject(temp)
        } else {
            let temp = FilterRealmEntity()
            temp.from = self.from
            temp.to = self.to
            dependencies.realmManager.saveObject(temp)
        }
    }
}



