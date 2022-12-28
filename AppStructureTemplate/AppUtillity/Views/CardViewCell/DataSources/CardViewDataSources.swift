//
//  CardViewDataSources.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import RxSwift
import RxCocoa
import RxDataSources

final class CardViewDataSources {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    typealias TableViewDataSource = RxTableViewSectionedReloadDataSource<CardViewSectionModel>
            
    // MARK: - Initial Value
    var sections = BehaviorRelay<[CardViewSectionModel]>(value: [])
    var dataSource: TableViewDataSource!
    
    init(sectionItems: [CardViewSectionModel] = []) {
        sections.accept(sectionItems)
        self.dataSource = TableViewDataSource(configureCell: configureCell(), titleForHeaderInSection: titleForHeaderInSection())
    }
    
    func titleForHeaderInSection() -> TableViewDataSource.TitleForHeaderInSection {
        return { dataSource, section in
            let header = dataSource.sectionModels[section].header
            return header
        }
    }
    
    func configureCell() -> TableViewDataSource.ConfigureCell {
        return { _, tv, ip, item in
            let cell = tv.dequeue(cellClass: CardViewCell.self, forIndexPath: ip)
            cell.configure(with: item)
            return cell
        }
    }
    
}

