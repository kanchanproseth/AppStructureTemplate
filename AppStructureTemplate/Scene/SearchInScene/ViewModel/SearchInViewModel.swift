//
//  SearchInViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import RxSwift
import RxCocoa

typealias SearchInViewModelDependencies = (
    realmManager: RealmManager,
    coordinator: SearchInCoordinator
)

protocol SearchInViewModelInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var clearTrigger: PublishRelay<Void> { get }
    var backTrigger: PublishRelay<Void> { get }
    var isSearchByTitleTrigger: PublishRelay<Bool> { get }
    var isSearchByDescriptionTrigger: PublishRelay<Bool> { get }
    var isSearchByContentTrigger: PublishRelay<Bool> { get }
    var applyTrigger: PublishRelay<Void> { get }
}

protocol SearchInViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishRelay<Error?> { get }
    var isCear: PublishRelay<Void> { get }
    var isSearchByTitle: PublishRelay<Bool> { get }
    var isSearchByDescription: PublishRelay<Bool> { get }
    var isSearchByContent: PublishRelay<Bool> { get }
}

protocol SearchInViewModelInterface {
    var inputs: SearchInViewModelInputs { get }
    var outputs: SearchInViewModelOutputs { get }
}

final class SearchInViewModel: SearchInViewModelInterface, SearchInViewModelOutputs, SearchInViewModelInputs {
    
    var inputs: SearchInViewModelInputs { return self }
    var outputs: SearchInViewModelOutputs { return self }
    
    // MARK: - Intputs
    var viewDidLoadTrigger = PublishSubject<Void>()
    var clearTrigger = PublishRelay<Void>()
    var backTrigger = PublishRelay<Void>()
    var isSearchByTitleTrigger = PublishRelay<Bool>()
    var isSearchByDescriptionTrigger = PublishRelay<Bool>()
    var isSearchByContentTrigger = PublishRelay<Bool>()
    var applyTrigger = PublishRelay<Void>()
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var isError = PublishRelay<Error?>()
    var isCear = PublishRelay<Void>()
    var isSearchByTitle = PublishRelay<Bool>()
    var isSearchByDescription = PublishRelay<Bool>()
    var isSearchByContent = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    private var searchBy: [SearchInViewModel.searchByType: Bool] = [:]
    
    internal enum searchByType{
        case title
        case description
        case content
    }
    
    
    init(dependencies: SearchInViewModelDependencies) {
        
        viewDidLoadTrigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
                guard let model = data.first as? FilterRealmEntity else { return }
                self.searchBy[.title] = model.searchByTitle
                self.searchBy[.description] = model.searchByDescription
                self.searchBy[.content] = model.searchByContent
                self.isSearchByTitle.accept(model.searchByTitle)
                self.isSearchByDescription.accept(model.searchByDescription)
                self.isSearchByContent.accept(model.searchByContent)
            }
        }).disposed(by: disposeBag)
        
        isSearchByTitleTrigger.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            self.searchBy[.title] = value
        }).disposed(by: disposeBag)
        
        isSearchByDescriptionTrigger.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            self.searchBy[.description] = value
        }).disposed(by: disposeBag)
        
        isSearchByContentTrigger.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            self.searchBy[.content] = value
        }).disposed(by: disposeBag)
        
        applyTrigger
            .do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.apply(dependencies: dependencies)
            })
            .subscribe(onNext: {
                dependencies.coordinator.dismiss()
        }).disposed(by: disposeBag)

        
        backTrigger
            .subscribe(onNext: {
                dependencies.coordinator.dismiss()
            })
            .disposed(by: disposeBag)
        
        clearTrigger
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchBy[.title] = false
                self.searchBy[.description] = false
                self.searchBy[.content] = false
            })
            .bind(to: isCear)
            .disposed(by: disposeBag)
    }
    
}

private extension SearchInViewModel {
    func apply(dependencies: SearchInViewModelDependencies){
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), data.count > 0 {
            guard let model = data.first as? FilterRealmEntity else { return }
            let temp = FilterRealmEntity(value: model)
            temp.searchByTitle = self.searchBy[.title] ?? false
            temp.searchByDescription = self.searchBy[.description] ?? false
            temp.searchByContent = self.searchBy[.content] ?? false
            try? dependencies.realmManager.updateObject(temp)
        } else {
            let temp = FilterRealmEntity()
            temp.searchByTitle = self.searchBy[.title] ?? false
            temp.searchByDescription = self.searchBy[.description] ?? false
            temp.searchByContent = self.searchBy[.content] ?? false
            dependencies.realmManager.saveObject(temp)
        }
    }
}




