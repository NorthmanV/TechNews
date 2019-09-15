//
//  News+CoreDataProperties.swift
//  TechNews
//
//  Created by Ruslan Akberov on 14/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//
//

import Foundation
import CoreData

extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var url: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var descr: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: Data?

}
