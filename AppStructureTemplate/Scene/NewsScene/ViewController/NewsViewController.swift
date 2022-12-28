//
//  NewsViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class NewsViewController: UIViewController, StoryboardInstantiatable  {
    
    @IBOutlet private weak var tableView: UITableView!
    private var activityIndicatorView: NVActivityIndicatorView!
    
    static var storyboardName: String {
        return "News"
    }
    
    
    // MARK: - Properties
    var viewModel: NewsViewModelInterface!
    
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

private extension NewsViewController {
    func setupUI(){
        tableView.registerNib(cellType: CardViewCell.self)
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.maxX/2, y: self.view.bounds.maxY/2, width: 50, height: 50),
                                                             type: .pacman,
                                                             color: UIColor.orange.withAlphaComponent(0.7))
        self.view.addSubview(activityIndicatorView)
        self.tableView.backgroundColor = UIColor.systemGray6
    }
    
    func setBinding(){
        
        viewModel.outputs.sections
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(dataSource: viewModel.outputs.dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
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

