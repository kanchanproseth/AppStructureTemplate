//
//  SearchHistoryItem.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 08/03/2022.
//

import Foundation

protocol SearchHistoryCellItemConfigurable {
    func configure(with item: SearchHistoryItem)
}

struct SearchHistoryItem {
    var title: String?
    
    init(title: String) {
        self.title = title
    }
}

