//
//  SortView.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 10/03/2022.
//

import UIKit
import RxSwift
import RxRelay

public class SortView: UIView {
    
    
    @IBOutlet private weak var sortViewContainer: UIView!
    
    @IBOutlet private weak var updateDateTapView: UIView!
    @IBOutlet private weak var updateDateRadioView: UIView!
    
    @IBOutlet private weak var relavanceTapView: UIView!
    @IBOutlet private weak var relavanceRadioView: UIView!
    
    private var shadowView: UIView!
    
    public var updateDateViewTapTrigger = PublishRelay<Void>()
    public var relevanceViewTapTrigger = PublishRelay<Void>()
    public var viewTapTrigger = PublishRelay<Void>()
    
    private var showFrame: CGRect!
    private var hideFrame: CGRect!
    private var disposeBag = DisposeBag()
    
    // MARK: - Properties
    indirect enum SortType: String {
        case updateDate = "publishedAt"
        case relevance = "relevance"
    }
    
    // MARK: - Lifecycle Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpBinding()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        setUpBinding()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpUI()
    }
    
    func configureSelectRadioView(_ sort: SortType) {
        switch sort {
        case .updateDate:
            selectUpdateDate()
        case .relevance:
            selectRelevance()
        }
    }
    
}

// MARK: - UI Setup
private extension SortView {
    
    func setUpUI() {
        let viewFromNib = viewFromOwnedNib()
        addSubviewAndFill(viewFromNib)
        
        shadowView = UIView(frame: sortViewContainer.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.cornerRadius = 20.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5
        
        updateDateRadioView.layer.cornerRadius = 12
        updateDateRadioView.layer.masksToBounds = true
        updateDateRadioView.backgroundColor = UIColor.systemGray5
        
        relavanceRadioView.layer.cornerRadius = 12
        relavanceRadioView.layer.masksToBounds = true
        relavanceRadioView.backgroundColor = UIColor.systemGray5
        
        addSubview(shadowView)
        sendSubviewToBack(shadowView)
        sortViewContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        
    }
    
    func setUpBinding() {
        let updateDateViewTapGesture = UITapGestureRecognizer()
        updateDateTapView.addGestureRecognizer(updateDateViewTapGesture)
        
        updateDateViewTapGesture.rx
            .event
            .map {_ in ()}
            .do(onNext: selectUpdateDate)
            .bind(to: updateDateViewTapTrigger)
            .disposed(by: disposeBag)
        
        let relevanceViewTapGesture = UITapGestureRecognizer()
        relavanceTapView.addGestureRecognizer(relevanceViewTapGesture)
        
        relevanceViewTapGesture.rx
            .event
            .map {_ in ()}
            .do(onNext: selectRelevance)
            .bind(to: relevanceViewTapTrigger)
            .disposed(by: disposeBag)
        
        let viewTapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(viewTapGesture)
        
        viewTapGesture.rx
            .event
            .map {_ in ()}
            .bind(to: viewTapTrigger)
            .disposed(by: disposeBag)
    }
    
    
    func selectUpdateDate(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.updateDateRadioView.layer.borderColor = UIColor.orange.withAlphaComponent(0.7).cgColor
            self.updateDateRadioView.layer.borderWidth = 5
            self.updateDateRadioView.backgroundColor = UIColor.white
            
            self.relavanceRadioView.layer.borderColor = UIColor.systemGray5.cgColor
            self.relavanceRadioView.layer.borderWidth = 0
            
        })
        self.layoutIfNeeded()
    }
    
    func selectRelevance(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.relavanceRadioView.layer.borderColor = UIColor.orange.withAlphaComponent(0.7).cgColor
            self.relavanceRadioView.layer.borderWidth = 5
            self.relavanceRadioView.backgroundColor = UIColor.white
            
            self.updateDateRadioView.layer.borderColor = UIColor.systemGray5.cgColor
            self.updateDateRadioView.layer.borderWidth = 0
        })
        self.layoutIfNeeded()
    }

    
}
