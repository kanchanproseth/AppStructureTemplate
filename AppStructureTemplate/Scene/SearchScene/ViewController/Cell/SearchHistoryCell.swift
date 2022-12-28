//
//  SearchHistoryCell.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 08/03/2022.
//

import UIKit
import RxSwift

class SearchHistoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    private (set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
        disposeBag = DisposeBag()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setUpUI()
        setUpBinding()
    }
    
    
}

extension SearchHistoryCell: SearchHistoryCellItemConfigurable {
    
    func configure(with item: SearchHistoryItem) {
        titleLabel.text = item.title
    }
}

// MARK: - UI Setup
private extension SearchHistoryCell {
    
    func clear() {
        titleLabel.text = nil
    }
    
    func setUpUI() {
        
    }
    
    func setUpBinding() {
        
    }
    
}
