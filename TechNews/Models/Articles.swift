//
//  Articles.swift
//  TechNews
//
//  Created by Ruslan Akberov on 11/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import Foundation

struct Articles: Codable {
    let news: [News]?
    
    enum CodingKeys: String, CodingKey {
        case news = "articles"
    }
}
