//
//  ViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift
import RxRelay

class MainViewController: UITabBarController, StoryboardInstantiatable  {
    
    static var storyboardName: String {
        return "Main"
    }
    
    private var mainNavigationView: MainNavigationView!
    private var sortView: SortView!
    private var shadowView: UIView!
    private var mainNavigationViewContainer: UIView!
    private var defaultFrame: CGRect!
    private var showSearchFrame: CGRect!
    
    public var filterRelay = PublishRelay<Void>()
    public var sortRelay = PublishRelay<Void>()
    public var searchRelay = PublishRelay<String>()
    public var showBadger = PublishRelay<(String,Bool)>()
    
    private let disposeBag = DisposeBag()
    
    var viewModel: MainViewModelInterface!

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupUI()
        setupBinding()
    }
    
}

extension MainViewController: UITabBarControllerDelegate  {}

private extension MainViewController {
    func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
        defaultFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 110)
        showSearchFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 170)
        mainNavigationView = MainNavigationView()
        mainNavigationView.showSearchView(show: false)
        shadowView = UIView(frame: defaultFrame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.cornerRadius = 20.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5
        
        mainNavigationViewContainer = UIView(frame: defaultFrame)
        view.addSubview(shadowView)
        view.bringSubviewToFront(shadowView)
        view.addSubview(mainNavigationViewContainer)
        view.bringSubviewToFront(mainNavigationViewContainer)
        mainNavigationViewContainer.addSubviewAndFill(mainNavigationView)
        mainNavigationViewContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
        
        
        
        self.tabBar.tintColor = UIColor.orange.withAlphaComponent(5)
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        sortView = SortView(frame: view.frame)
    }
 
    func setupBinding() {
        mainNavigationView
            .searchRelay
            .bind(to: self.searchRelay)
            .disposed(by: disposeBag)
        
        mainNavigationView
            .filterRelay
            .bind(to: self.filterRelay)
            .disposed(by: disposeBag)
        
        mainNavigationView
            .sortRelay
            .map{ _ in true }
            .subscribe(onNext: animateSortiew(show:))
            .disposed(by: disposeBag)
        
        sortView.viewTapTrigger
            .map{ _ in false}
            .subscribe(onNext: animateSortiew(show:))
            .disposed(by: disposeBag)
        
        sortView.updateDateViewTapTrigger
            .bind(to: viewModel.inputs.updateDateViewTapTrigger)
            .disposed(by: disposeBag)
        
        sortView.relevanceViewTapTrigger
            .bind(to: viewModel.inputs.relevanceViewTapTrigger)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .sortTypeConfigureView
            .subscribe(onNext: sortView.configureSelectRadioView)
            .disposed(by: disposeBag)
        
        showBadger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
            [weak self] value in
            guard let self = self else { return }
            self.mainNavigationView.badger(value.0, show: value.1)
        })
            .disposed(by: disposeBag)
    }
}

private extension MainViewController {
    func animateSearchView(show: Bool){
        if show {
            UIView.transition(with: mainNavigationViewContainer, duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.showBar()
            })
            
            
        } else {
            UIView.transition(with: mainNavigationViewContainer, duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.defaultBar()
            })
            
        }
        
        self.view.layoutIfNeeded()
    }
    
    func animateSortiew(show: Bool){
        if show {
            UIView.transition(with: sortView, duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.view.addSubview(self.sortView)
                self.view.bringSubviewToFront(self.sortView)
            })
            
            
        } else {
            UIView.transition(with: sortView, duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.sortView.removeFromSuperview()
            })
            
        }
        
        self.view.layoutIfNeeded()
    }
    
    func showBar() {
        mainNavigationViewContainer.frame = showSearchFrame
        mainNavigationView.showSearchView(show: true)
        shadowView.frame = showSearchFrame
        view.addSubview(mainNavigationViewContainer)
        view.bringSubviewToFront(mainNavigationViewContainer)
        mainNavigationViewContainer.addSubviewAndFill(mainNavigationView)
        mainNavigationViewContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    func defaultBar() {
        mainNavigationViewContainer.frame = defaultFrame
        mainNavigationView.showSearchView(show: false)
        shadowView.frame = defaultFrame
        view.addSubview(mainNavigationViewContainer)
        view.bringSubviewToFront(mainNavigationViewContainer)
        mainNavigationViewContainer.addSubviewAndFill(mainNavigationView)
        mainNavigationViewContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
}

extension MainViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        DispatchQueue.main.async {
            if item.title == MainTabBarEntity.search.title {
                self.animateSearchView(show: true)
            } else {
                self.animateSearchView(show: false)
            }
        }
        
    }
}

