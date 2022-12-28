//
//  NewsViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import RxCocoa

typealias NewsViewModelDependencies = (
    service: NewsService,
    coordinator: NewsCoordinator
)

protocol NewsViewModelInputs {
    var viewWillAppearTrigger: PublishSubject<Void> { get }
    var itemSelectedTrigger: PublishRelay<CardViewItem> { get }
}

protocol NewsViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishRelay<Error?> { get }
    var sections: BehaviorRelay<[CardViewSectionModel]> { get }
    var dataSource: CardViewDataSources.TableViewDataSource { get }
}

protocol NewsViewModelInterface {
    var inputs: NewsViewModelInputs { get }
    var outputs: NewsViewModelOutputs { get }
}

final class NewsViewModel: NewsViewModelInterface, NewsViewModelOutputs, NewsViewModelInputs {
    
    var inputs: NewsViewModelInputs { return self }
    var outputs: NewsViewModelOutputs { return self }
    
    // MARK: - Intputs
    var viewWillAppearTrigger = PublishSubject<Void>()
    var itemSelectedTrigger = PublishRelay<CardViewItem>()
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var isError = PublishRelay<Error?>()
    var sections: BehaviorRelay<[CardViewSectionModel]> = .init(value: [])
    var dataSource: CardViewDataSources.TableViewDataSource
    
    private let disposeBag = DisposeBag()
    
    
    init(dependencies: NewsViewModelDependencies) {
        
        // MARK: - DataSource.
        let dataSource = CardViewDataSources(sectionItems: sections.value)
        self.sections = dataSource.sections
        self.dataSource = dataSource.dataSource
        
        let requestNews = viewWillAppearTrigger
            .startLoading(loadingSubject: isLoading)
            .flatMapLatest {  _ -> Observable<Event<NewsEntity>> in
                return dependencies.service.requestTopHeadline().materialize()
            }.stopLoading(loadingSubject: isLoading)
            .share()
        
        itemSelectedTrigger
            .compactMap{ $0.url }
            .subscribe(onNext: dependencies.coordinator.presentToWebView(_:))
            .disposed(by: disposeBag)
        
        requestNews
            .compactMap { $0.element }
            .observe(on: MainScheduler.asyncInstance)
            .map{ model -> [CardViewSectionModel] in
                var section = [CardViewSectionModel]()
                let items = model.articles.unwrappedValue.map{ CardViewItem(model: $0) }
                section.append(CardViewSectionModel(header: "News", items: items))
                return section
            }.bind(to: sections)
            .disposed(by: disposeBag)
        
    }
}


