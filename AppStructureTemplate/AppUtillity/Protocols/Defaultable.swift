//
//  Defaultable.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Foundation

/*:
 stackoverflow reference [link.](https://stackoverflow.com/a/44202567/5553193)
 */
public protocol Defaultable {
    static var defaultValue: Self { get }
}

public extension Optional where Wrapped: Defaultable {
    var unwrappedValue: Wrapped { return self ?? Wrapped.defaultValue }
}

extension Int: Defaultable {
    public static var defaultValue: Int { return 0 }
}

extension Double: Defaultable {
    public static var defaultValue: Double { return 0.0 }
}

extension String: Defaultable {
    public static var defaultValue: String { return "" }
}

extension Array: Defaultable {
    public static var defaultValue: [Element] { return [] }
}

extension Bool: Defaultable {
    public static var defaultValue: Bool { return false }
}

