//
//  CardViewCell.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CardViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageViewContainer: UIImageView!
    
    private (set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        clear()
        disposeBag = DisposeBag()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setUpUI()
        setUpBinding()
    }
    
}

extension CardViewCell: CardViewCellItemConfigurable {
    
    func configure(with item: CardViewItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.desc
        guard let imageUrl = URL(string: item.imageUrl ?? "") else { return }
        KF.url(imageUrl)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .set(to: imageViewContainer)
    }
}

// MARK: - UI Setup
private extension CardViewCell {
    
    func setUpUI() {
        
    }
    
    func setUpBinding() {
        
    }
    
}


