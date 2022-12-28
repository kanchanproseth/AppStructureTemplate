//
//  SearchViewModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import RxSwift
import RxCocoa

typealias SearchViewModelDependencies = (
    realmManager: RealmManager,
    service: NewsService,
    coordinator: SearchCoordinator
)

protocol SearchViewModelInputs {
    var viewWillAppearTrigger: PublishSubject<Void> { get }
    var itemSelectedTrigger: PublishRelay<CardViewItem> { get }
}

protocol SearchViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var isError: PublishRelay<Error?> { get }
    var sections: BehaviorRelay<[CardViewSectionModel]> { get }
    var dataSource: CardViewDataSources.TableViewDataSource { get }
    var searchHistorySections: BehaviorRelay<[SearchHistorySectionModel]> { get }
    var searchHistoryDataSource: SearchHistoryDataSources.TableViewDataSource { get }
    var isSearching: PublishRelay<Bool> { get }
}

protocol SearchViewModelInterface {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutputs { get }
}

final class SearchViewModel: SearchViewModelInterface, SearchViewModelOutputs, SearchViewModelInputs {
    
    var inputs: SearchViewModelInputs { return self }
    var outputs: SearchViewModelOutputs { return self }
    
    // MARK: - Intputs
    var viewWillAppearTrigger = PublishSubject<Void>()
    var itemSelectedTrigger = PublishRelay<CardViewItem>()
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var isError = PublishRelay<Error?>()
    var sections: BehaviorRelay<[CardViewSectionModel]> = .init(value: [])
    var dataSource: CardViewDataSources.TableViewDataSource
    var isSearching = PublishRelay<Bool>()
    
    var searchHistorySections: BehaviorRelay<[SearchHistorySectionModel]> = .init(value: [])
    var searchHistoryDataSource: SearchHistoryDataSources.TableViewDataSource
    
    private let disposeBag = DisposeBag()
    
    
    init(dependencies: SearchViewModelDependencies) {
        
        // MARK: - DataSource.
        let dataSource = CardViewDataSources(sectionItems: sections.value)
        self.sections = dataSource.sections
        self.dataSource = dataSource.dataSource
        
        let searchHistoryDataSource = SearchHistoryDataSources(sectionItems: searchHistorySections.value)
        self.searchHistorySections = searchHistoryDataSource.sections
        self.searchHistoryDataSource = searchHistoryDataSource.dataSource

        viewWillAppearTrigger.map {_ in
            [
                SearchHistorySectionModel(header: "Search History", items: [
                    SearchHistoryItem(title: "MediaPark"),
                    SearchHistoryItem(title: "Ukrain News"),
                    SearchHistoryItem(title: "Russian"),
                    SearchHistoryItem(title: "Software Engineer")
                ])
            ]
        }
        .do(onNext: { [weak self] _ in
            guard let self = self else { return }
            let localData = self.checkFilterLocalData(dependencies: dependencies)
            var searchBy = [String]()
            if (localData.searchByTitle == true) { searchBy.append("title")}
            if (localData.searchByDescription == true) { searchBy.append("description")}
            if (localData.searchByContent == true) { searchBy.append("content")}
            if searchBy.count > 0 {
                dependencies.coordinator.showBadger.accept(("\(searchBy.count)", true))
            } else {
                dependencies.coordinator.showBadger.accept(("", false))
            }
        })
        .bind(to: searchHistorySections).disposed(by: disposeBag)
        
            dependencies.coordinator
            .searchRelay
            .filter{ $0.isEmpty }
            .map{ _ in false}
            .bind(to: isSearching)
            .disposed(by: disposeBag)
            
        let requestSearch = dependencies.coordinator
            .searchRelay
            .asObservable()
            .filter{ !$0.isEmpty }
            .startLoading(loadingSubject: isLoading)
            .flatMapLatest { text -> Observable<Event<NewsEntity>> in
                let localData = self.checkFilterLocalData(dependencies: dependencies)
                var searchBy = [String]()
                if (localData.searchByTitle == true) { searchBy.append("title")}
                if (localData.searchByDescription == true) { searchBy.append("description")}
                if (localData.searchByContent == true) { searchBy.append("content")}
                
                return dependencies.service
                    .requestSearchNews(query: text,
                                       filter: searchBy.count > 0 ? searchBy.joined(separator: ",") : nil,
                                       from: localData.from,
                                       to: localData.to,
                                       sortBy: localData.sort)
                    .materialize()
                
            }.stopLoading(loadingSubject: isLoading)
            .share()
        
        itemSelectedTrigger
            .compactMap{ $0.url }
            .subscribe(onNext: dependencies.coordinator.presentToWebView(_:))
            .disposed(by: disposeBag)
        
        requestSearch
            .compactMap { $0.element }
            .observe(on: MainScheduler.asyncInstance)
            .map{ model -> [CardViewSectionModel] in
                var section = [CardViewSectionModel]()
                let items = model.articles.unwrappedValue.map{ CardViewItem(model: $0) }
                section.append(CardViewSectionModel(header: "Search", items: items))
                return section
            }.do(onNext: { [weak self] _ in
                self?.isSearching.accept(true)
            }).bind(to: sections)
            .disposed(by: disposeBag)
        
        dependencies.coordinator
            .filterRelay
            .subscribe(onNext: {
                let _ = dependencies.coordinator.moveToFilter()
        }).disposed(by: disposeBag)
        
    }
}

private extension SearchViewModel {
    func checkFilterLocalData(dependencies: SearchViewModelDependencies) -> FilterRealmEntity {
        let temp = FilterRealmEntity()
        if let data =  dependencies.realmManager.fetchObjects(FilterRealmEntity.self), let model = data.first as? FilterRealmEntity, data.count > 0 {
            return model
        } else {
            dependencies.realmManager.saveObject(temp)
            return temp
        }
    }
}
