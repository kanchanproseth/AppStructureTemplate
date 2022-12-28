//
//  UITableView+Extensions.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import UIKit

public extension UITableView {
    
    // MARK: - Register Cell
    func registerClass<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.className)
    }
    
    func registerNib<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = nibType(type: cellType.self, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func registerClasses<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { registerClass(cellType: $0) }
    }
    
    func registerNibs<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { registerNib(cellType: $0, bundle: bundle) }
    }
    
    // MARK: - Register Header and Footer
    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(cellType: T.Type) {
        register(cellType, forHeaderFooterViewReuseIdentifier: cellType.className)
    }
    
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = nibType(type: cellType, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    // MARK: - Dequeue
    func dequeue<T: UITableViewHeaderFooterView>(headerFooterClass: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.className) as? T else {
            fatalError("Error: headerFooterView with id: \(headerFooterClass.className) is not \(T.self)")
        }
        return view
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.className) as? T else {
            fatalError("Error: cell with id: \(cellClass.className) is not \(T.self)")
        }
        return cell
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
                withIdentifier: cellClass.className, for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(cellClass.className) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
}

private extension UITableView {
    
    func nibType<T: UIView>(type: T.Type, bundle: Bundle? = nil) -> UINib {
        let rawBundle = bundle == nil ? Bundle(for: type) : bundle
        return UINib(nibName: type.className, bundle: rawBundle)
    }
    
}

