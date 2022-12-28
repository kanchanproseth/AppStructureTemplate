//
//  UIView+Extension.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import UIKit

public extension UIView {
    
    func fillSuperview() {
        guard let superview = superview
        else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        ]
        constraints.forEach {
            $0.priority = UILayoutPriority(999)
            $0.isActive = true
        }
    }
    
    @discardableResult
    func addSubviewAndFill(_ subview: UIView,
                           inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            subview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: inset.bottom),
            rightAnchor.constraint(equalTo: subview.rightAnchor, constant: inset.right)
        ]
        constraints.forEach {
            $0.isActive = true
        }
        return constraints
    }
    
    @discardableResult
    func addSubviewCenterXY(_ subview: UIView, width: CGFloat? = nil,
                            height: CGFloat? = nil) -> [NSLayoutConstraint] {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [
            subview.centerXAnchor.constraint(equalTo: centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        if let rawWidth = width, let rawHeight = height {
            let rawConstraints = [
                subview.widthAnchor.constraint(equalToConstant: rawWidth),
                subview.heightAnchor.constraint(equalToConstant: rawHeight)
            ]
            constraints.append(contentsOf: rawConstraints)
        }
        constraints.forEach {
            $0.isActive = true
        }
        return constraints
    }
    
}

public extension UIView {
    
    @discardableResult
    func anchorSize(_ size: CGSize, isActive: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        constraints.forEach {
            $0.isActive = isActive
        }
        return constraints
    }
    
}

public extension UIView {
    
    func viewFromOwnedNib(named nibName: String? = nil) -> UIView {
        let bundle = Bundle(for: self.classForCoder)
        return {
            if let nibName = nibName {
                return bundle.loadNibNamed(nibName, owner: self, options: nil)!.last as! UIView
            }
            return bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)!.last as! UIView
            }()
    }
    
    /// Convenience function for creating a view from a nib file.
    /// Returns an instance of the `UIView` subclass that called the function.
    class func instantiateFromNib() -> Self {
        return self.instantiateFromNib(in: Bundle.main)
    }
    
}

fileprivate extension UIView {
    
    /// Creates a `UIView` subclass from a nib file of the same name. If an XIB file of the same name
    /// as the class does not exist and this function is invoked, a fatal error is thrown
    /// since it is a developer error that must definitely be fixed.
    class func instantiateFromNib<T>(in bundle: Bundle) -> T {
        let objects = bundle.loadNibNamed(String(describing: self), owner: self, options: nil)!
        let view = objects.last as! T
        return view
    }
    
}

public extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
