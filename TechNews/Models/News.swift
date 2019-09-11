//
//  News.swift
//  TechNews
//
//  Created by Ruslan Akberov on 11/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import Foundation

struct News: Codable {
    var title: String?
    var description: String?
    var imageUrl: String?
    
    enum ContainerKeys: String, CodingKey {
        case articles
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl = "urlToImage"
    }
}
