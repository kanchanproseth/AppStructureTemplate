//
//  HomeViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController, StoryboardInstantiatable  {
    
    static var storyboardName: String {
        return "Home"
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

