//
//  NewsModel.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Foundation

extension CardViewItem {
    
    init(model: Article){
        self.title = model.title
        self.desc = model.description
        self.imageUrl = model.image
        self.url = model.url
    }
}
