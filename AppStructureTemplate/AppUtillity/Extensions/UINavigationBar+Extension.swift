//
//  UINavigationBar+Extension.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import UIKit

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
