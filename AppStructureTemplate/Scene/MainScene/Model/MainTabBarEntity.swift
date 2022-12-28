//
//  MainTabBarEntity.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import UIKit

enum MainTabBarEntity: Int {
    case home
    case news
    case search
    case profile
    case more
    
    var title: String? {
        switch self {
        case .home:
            return "Home"
        case .news:
            return "News"
        case .search:
            return "search"
        case .profile:
            return "Profile"
        case .more:
            return "More"
        }
    }
    
    var icon: UIImage? {
        switch self {
            
        case .home:
            return UIImage(named: "homeIcon")?.resizeImage(15.0, opaque: false)
        case .news:
            return UIImage(named: "newsIcon")?.resizeImage(15.0, opaque: false)
        case .search:
            return UIImage(named: "searchIcon")?.resizeImage(15.0, opaque: false)
        case .profile:
            return UIImage(named: "userIcon")?.resizeImage(15.0, opaque: false)
        case .more:
            return UIImage(named: "moreIcon")?.resizeImage(15.0, opaque: false)
        }
    }
    
    var navigationController: UINavigationController {
        let navigation = UINavigationController()
        navigation.tabBarItem.title = self.title
        navigation.tabBarItem.image = self.icon
        return navigation
    }
}

