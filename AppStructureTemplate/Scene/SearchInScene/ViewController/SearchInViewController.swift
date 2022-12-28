//
//  SearchInViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import UIKit
import RxSwift

class SearchInViewController: UIViewController, StoryboardInstantiatable  {
    
    static var storyboardName: String {
        return "SearchIn"
    }
    @IBOutlet private weak var titleSwitch: UISwitch!
    @IBOutlet private weak var descriptionSwitch: UISwitch!
    @IBOutlet private weak var contentSwitch: UISwitch!
    @IBOutlet private weak var applyButton: UIButton!
    // MARK: - Properties
    var viewModel: SearchInViewModelInterface!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBinding()
    }
}


private extension SearchInViewController {
    func setupUI(){
        setupNavigationLogo()
        setupSwitch()
        setupApplyButton()
    }
    
    func setBinding(){
        setupBackButton()
            .bind(to: viewModel.inputs.backTrigger)
            .disposed(by: disposeBag)
        
        setupClearButton()
            .bind(to: viewModel.inputs.clearTrigger)
            .disposed(by: disposeBag)
        
        self.applyButton
            .rx
            .tap
            .bind(to: viewModel.inputs.applyTrigger)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isCear
            .map{ _ in false}
            .bind(to: titleSwitch.rx.isOn, descriptionSwitch.rx.isOn, contentSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isSearchByTitle
            .bind(to: titleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isSearchByDescription.bind(to: descriptionSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isSearchByContent
            .bind(to: contentSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        titleSwitch.rx
            .controlEvent([.valueChanged])
            .withLatestFrom(titleSwitch.rx.isOn)
            .bind(to: viewModel.inputs.isSearchByTitleTrigger)
            .disposed(by: disposeBag)
        
        descriptionSwitch.rx
            .controlEvent([.valueChanged])
            .withLatestFrom(descriptionSwitch.rx.isOn)
            .bind(to: viewModel.inputs.isSearchByDescriptionTrigger)
            .disposed(by: disposeBag)
        
        contentSwitch.rx
            .controlEvent([.valueChanged])
            .withLatestFrom(contentSwitch.rx.isOn)
            .bind(to: viewModel.inputs.isSearchByContentTrigger)
            .disposed(by: disposeBag)
        
        viewModel.inputs.viewDidLoadTrigger.onNext(())
        
        
    }
}

private extension SearchInViewController {
    
    func setupApplyButton() {
        applyButton.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
        applyButton.layer.cornerRadius = 25
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.setTitle("Apply", for: .normal)
    }
    
    func setupSwitch() {
        self.titleSwitch.onTintColor = UIColor.orange.withAlphaComponent(0.5)
        self.descriptionSwitch.onTintColor = UIColor.orange.withAlphaComponent(0.5)
        self.contentSwitch.onTintColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    func setupNavigationLogo() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func setupBackButton() -> Observable<Void> {
        let icon = UIImage(named: "arrowLeftIcon")!.resizeImage(15, opaque: false)
        let barButtonItem = UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        barButtonItem.tintColor = UIColor.orange.withAlphaComponent(0.5)
        self.navigationItem.leftBarButtonItem = barButtonItem
        return barButtonItem.rx.tap.asObservable()
    }
    
    func setupClearButton() -> Observable<Void> {
        let button = UIButton(type: .system)
        let icon = UIImage(named: "trashIcon")!.resizeImage(15, opaque: false)
        button.setImage(icon, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitle("clear", for: .normal)
        button.tintColor = UIColor.orange.withAlphaComponent(0.5)
        button.setTitleColor(UIColor.orange.withAlphaComponent(0.5), for: .normal)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button.rx.tap.asObservable()
    }
}
