//
//  CardViewItem.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Foundation

protocol CardViewCellItemConfigurable {
    func configure(with item: CardViewItem)
}

struct CardViewItem {
    var title: String?
    var desc: String?
    var imageUrl: String?
    var url: String?
    
    public init(){ }
}
