//
//  MainNavigationView.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import UIKit
import RxSwift
import RxRelay

public class MainNavigationView: UIView {
    
    // MARK: - Properties
    @IBOutlet private weak var backgroundContainer: UIView!
    @IBOutlet private weak var searchStackView: UIStackView!
    @IBOutlet private weak var searchTextField: PaddingTextField!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var badgerLabel: UILabel!
    
    public var filterRelay = PublishRelay<Void>()
    public var sortRelay = PublishRelay<Void>()
    public var searchRelay = PublishRelay<String>()
    
    private var disposeBag = DisposeBag()
    
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
    
    func showSearchView(show: Bool){
        searchStackView.isHidden = !show
        if show == false {
            badgerLabel.isHidden = true
        }
        
    }
    
    func badger(_ text: String, show: Bool){
        badgerLabel.text = text
        badgerLabel.isHidden = !show
    }
}

// MARK: - UI Setup
private extension MainNavigationView {
    
    func setUpUI() {
        let viewFromNib = viewFromOwnedNib()
        addSubviewAndFill(viewFromNib)
        
        badgerLabel.layer.masksToBounds = true
        badgerLabel.layer.cornerRadius = 10

        searchTextField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.contentMode = .center
        let image = UIImage(named: "searchIcon")?.resizeImage(15, opaque: false)
        imageView.image = image
        searchTextField.leftView = imageView
        searchTextField.leftView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        searchTextField.layer.cornerRadius = 20
        searchTextField.placeholder = "Search"
        
        filterButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        filterButton.setImage(UIImage(named: "filterIcon")?.resizeImage(15, opaque: false), for: .normal)
        filterButton.tintColor = UIColor.lightGray
        filterButton.layer.cornerRadius = 20
        sortButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        sortButton.setImage(UIImage(named: "sortIcon")?.resizeImage(15, opaque: false), for: .normal)
        sortButton.layer.cornerRadius = 20
        sortButton.tintColor = UIColor.lightGray
    }
    
    func setUpBinding() {
        
        filterButton.rx.tap
            .bind(to: filterRelay)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind(to: sortRelay)
            .disposed(by: disposeBag)
        
        searchTextField.rx
            .controlEvent([.editingDidEnd])
            .withLatestFrom(searchTextField.rx.text)
            .compactMap{ $0 }
            .bind(to: searchRelay)
            .disposed(by: disposeBag)
        
    }
    
}
