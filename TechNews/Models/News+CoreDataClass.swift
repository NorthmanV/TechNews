//
//  News+CoreDataClass.swift
//  TechNews
//
//  Created by Ruslan Akberov on 14/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(News)
public class News: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case imageUrl = "urlToImage"
        case title
        case descr = "description"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "News", in: managedObjectContext) else {
                fatalError("Failed to decode News!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? "undefined"
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        descr = try container.decodeIfPresent(String.self, forKey: .descr)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(title, forKey: .title)
        try container.encode(descr, forKey: .descr)
    }

}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
