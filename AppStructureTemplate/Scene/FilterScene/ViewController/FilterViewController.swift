//
//  FilterViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import UIKit
import RxSwift
import RxRelay
import SwiftUI

class FilterViewController: UIViewController, StoryboardInstantiatable  {
    
    static var storyboardName: String {
        return "Filter"
    }
    
    @IBOutlet private weak var fromDateTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet private weak var toDateTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet private weak var searchTypeContainerView: UIStackView!
    @IBOutlet private weak var searchTypeLabel: UILabel!
    private let fromDatePicker: UIDatePicker = UIDatePicker()
    private let toDatePicker: UIDatePicker = UIDatePicker()
    @IBOutlet weak var applyButton: UIButton!
    
    // MARK: - Properties
    var viewModel: FilterViewModelInterface!
    
    private let disposeBag = DisposeBag()
    private let doneAction = PublishRelay<Void>()
    private let cancelAction = PublishRelay<Void>()
    
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

private extension FilterViewController {
    func setupUI(){
        setupNavigationLogo()
        setupTextField()
        setupApplyButton()
    }
    
    func bindToolBarAction(){
        doneAction.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        cancelAction.subscribe(onNext: {[weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    func bindFromTextfield(){
        fromDateTextField.rx.controlEvent([.editingDidEnd])
            .withLatestFrom(fromDatePicker.rx.value)
            .map{ date in date.toString(with: .option16) }
            .do(onNext: viewModel.inputs.fromDateTrigger.accept(_:))
            .bind(to: fromDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        fromDatePicker
            .rx
            .controlEvent([.valueChanged])
            .withLatestFrom(fromDatePicker.rx.value)
            .map{ date in date.toString(with: .option16) }
            .do(onNext: viewModel.inputs.fromDateTrigger.accept(_:))
            .bind(to: fromDateTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindToTextfield(){
        toDateTextField.rx
                .controlEvent([.editingDidEnd])
                .withLatestFrom(toDatePicker.rx.value)
                .map{ date in date.toString(with: .option16) }
                .do(onNext: viewModel.inputs.toDateTrigger.accept(_:))
                .bind(to: toDateTextField.rx.text)
                .disposed(by: disposeBag)
                
        toDatePicker.rx
                .controlEvent([.valueChanged])
                .withLatestFrom(toDatePicker.rx.value)
                .map{ $0.toString(with: .option16) }
                .do(onNext: viewModel.inputs.toDateTrigger.accept(_:))
                .bind(to: toDateTextField.rx.text)
                .disposed(by: disposeBag)
    }
    
    func setBinding(){
        
        setupBackButton()
            .bind(to: viewModel.inputs.backTrigger)
            .disposed(by: disposeBag)
        
        setupClearButton()
            .bind(to: viewModel.inputs.clearTrigger)
            .disposed(by: disposeBag)
        
        bindToolBarAction()
        bindFromTextfield()
        bindToTextfield()
        
        applyButton
            .rx
            .tap
            .bind(to: viewModel.inputs.applyTrigger)
            .disposed(by: disposeBag)
                        
        viewModel
            .outputs
            .searchBy
            .bind(to: searchTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .fromDate
            .bind(to: fromDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .toDate.bind(to: toDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .isCear
            .subscribe(onNext: self.reset)
            .disposed(by: disposeBag)
                        
        let tapGesture = UITapGestureRecognizer()
        searchTypeContainerView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.map {_ in ()}
            .subscribe(onNext: self.viewModel.inputs.searchTypeTapTrigger.accept(_:))
            .disposed(by: disposeBag)
        
        
        viewModel.inputs.viewDidLoadTrigger.onNext(())
    }
}

private extension FilterViewController {
    
    func setupNavigationLogo() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func setupApplyButton() {
        applyButton.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
        applyButton.layer.cornerRadius = 25
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.setTitle("Apply Filter", for: .normal)
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
    
    func setupTextField(){
        
        fromDateTextField.lineColor = UIColor.orange.withAlphaComponent(0.5)
        fromDateTextField.selectedLineColor = UIColor.orange.withAlphaComponent(0.5)
        fromDateTextField.titleColor = UIColor.orange.withAlphaComponent(0.5)
        fromDateTextField.selectedTitleColor = UIColor.orange.withAlphaComponent(0.5)
        
        fromDateTextField.inputView = fromDatePicker
        fromDateTextField.tintColor = UIColor.clear
        
        fromDateTextField.placeholder = "yyyy/mm/dd"
        fromDateTextField.title = "From"
        
        
        fromDateTextField.rightViewMode = UITextField.ViewMode.always
        fromDateTextField.rightView = UIImageView(image: UIImage(named : "calendar")!.resizeImage(15, opaque: false))
        
        toDateTextField.rightViewMode = UITextField.ViewMode.always
        toDateTextField.rightView = UIImageView(image: UIImage(named : "calendar")!.resizeImage(15, opaque: false))
        
        toDateTextField.lineColor = UIColor.orange.withAlphaComponent(0.5)
        toDateTextField.selectedLineColor = UIColor.orange.withAlphaComponent(0.5)
        toDateTextField.titleColor = UIColor.orange.withAlphaComponent(0.5)
        toDateTextField.selectedTitleColor = UIColor.orange.withAlphaComponent(0.5)
        
        toDateTextField.placeholder = "yyyy/mm/dd"
        toDateTextField.title = "To"
        toDateTextField.inputView = toDatePicker
        toDateTextField.tintColor = UIColor.clear
        
        addToolBar(textField: fromDateTextField, doneAction: doneAction, cancelAction: cancelAction)
        addToolBar(textField: toDateTextField, doneAction: doneAction, cancelAction: cancelAction)
        
        setupDatePicker(datePicker: fromDatePicker)
        setupDatePicker(datePicker: toDatePicker)
    }
    
    func setupDatePicker(datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        //Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
    }
}

extension FilterViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField,
                    doneAction: PublishRelay<Void> = PublishRelay<Void>(),
                    cancelAction: PublishRelay<Void> = PublishRelay<Void>()){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: nil)
        doneButton.rx.tap
            .bind(to: doneAction)
            .disposed(by: disposeBag)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        cancelButton.rx.tap
            .bind(to: cancelAction)
            .disposed(by: disposeBag)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
}

extension FilterViewController {
    func reset(){
        fromDateTextField.text = nil
        toDateTextField.text = nil
        searchTypeLabel.text = nil
    }
}
