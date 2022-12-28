//
//  CardView.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit

@IBDesignable
public class CardView: UIView {
    
    @IBInspectable public var cornerRadius: CGFloat = 5
    @IBInspectable public var shadowOffsetWidth: CGFloat = 0.2
    @IBInspectable public var shadowOffsetHeight: CGFloat = 0.2
    @IBInspectable public var shadowColor: UIColor? = UIColor.black
    @IBInspectable public var shadowOpacity: Float = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}

// MARK: - UI Setup
private extension CardView {
    
    func setUpUI() {
        clipsToBounds = true
    }
}
