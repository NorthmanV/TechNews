//
//  News+CoreDataClass.swift
//  TechNews
//
//  Created by Ruslan Akberov on 14/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//
//

import UIKit
import CoreData

@objc(News)
public class News: NSManagedObject, Codable {
        
    enum CodingKeys: String, CodingKey {
        case url
        case imageUrl = "urlToImage"
        case title
        case descr = "description"
        case date = "publishedAt"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "News", in: managedObjectContext) else {
                fatalError("Failed to decode News!")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        descr = try container.decodeIfPresent(String.self, forKey: .descr)
        let dateString = try container.decodeIfPresent(String.self, forKey: .date)
        date = convertToDate(dateString: dateString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(title, forKey: .title)
        try container.encode(descr, forKey: .descr)
    }
    
    private func convertToDate(dateString: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let dateString = dateString, let date = dateFormatter.date(from: dateString) else {
            return Date()
        }
        return date
    }
    
    func downloadImage(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        NetworkService.shared.downloadImage(url: imageUrl) { downloadedImage in
            self.image = downloadedImage?.jpegData(compressionQuality: 0.50)
            dispatchGroup.leave()
        }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
