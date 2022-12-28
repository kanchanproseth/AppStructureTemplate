//
//  ClassNameProtocol.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

