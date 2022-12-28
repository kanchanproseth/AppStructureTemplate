//
//  SearchViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class SearchViewController: UIViewController, StoryboardInstantiatable  {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTableView: UITableView!
    private var activityIndicatorView: NVActivityIndicatorView!
    
    static var storyboardName: String {
        return "Search"
    }
    
    // MARK: - Properties
    var viewModel: SearchViewModelInterface!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppearTrigger.onNext(())
    }
    
}


private extension SearchViewController {
    func setupUI(){
        searchTableView.registerNib(cellType: CardViewCell.self)
        tableView.registerNib(cellType: SearchHistoryCell.self)
        tableView.backgroundColor = UIColor.systemGray6
        searchTableView.backgroundColor = UIColor.systemGray6
        view.backgroundColor = UIColor.systemGray6
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.maxX/2, y: self.view.bounds.maxY/2, width: 50, height: 50),
                                                             type: .pacman,
                                                             color: UIColor.orange.withAlphaComponent(0.7))
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.view.bringSubviewToFront(self.tableView)
    }
    
    func setBinding(){
        
        viewModel.outputs.sections
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: searchTableView.rx.items(dataSource: viewModel.outputs.dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .isSearching
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: animateChangeTableView(_:))
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchHistorySections
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(dataSource: viewModel.outputs.searchHistoryDataSource))
            .disposed(by: disposeBag)
        
        searchTableView.rx
            .modelSelected(CardViewItem.self)
            .bind(to: viewModel.inputs.itemSelectedTrigger)
                    .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }).disposed(by: disposeBag)
        
    }
}

private extension SearchViewController {
    func animateChangeTableView(_ isSearching: Bool) {
        UIView.transition(with: view, duration: 1,
                          options: isSearching ? .transitionCurlDown : .transitionCurlUp,
                          animations: {
            isSearching ?
            self.view.bringSubviewToFront(self.searchTableView) :
            self.view.bringSubviewToFront(self.tableView)
        })
        self.view.bringSubviewToFront(activityIndicatorView)
        view.layoutIfNeeded()
    }
}
