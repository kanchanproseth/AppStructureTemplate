//
//  CardViewSectionModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct CardViewSectionModel {
    var header: String
    var items: [Item]
}
extension CardViewSectionModel: SectionModelType {
    typealias Item = CardViewItem
    
    init(original: CardViewSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
