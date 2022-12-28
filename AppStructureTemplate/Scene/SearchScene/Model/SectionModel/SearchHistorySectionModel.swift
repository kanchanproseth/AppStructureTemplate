//
//  SearchHistorySectionModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 08/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SearchHistorySectionModel {
    var header: String
    var items: [Item]
}

extension SearchHistorySectionModel: SectionModelType {
    typealias Item = SearchHistoryItem
    
    init(original: SearchHistorySectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

