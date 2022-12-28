//
//  PaddingTextField.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 07/03/2022.
//

import UIKit


class PaddingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
