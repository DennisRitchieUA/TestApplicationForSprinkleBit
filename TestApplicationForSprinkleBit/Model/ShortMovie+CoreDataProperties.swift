//
//  ShortMovie+CoreDataProperties.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/12/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//
//

import Foundation
import CoreData


extension ShortMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortMovie> {
        return NSFetchRequest<ShortMovie>(entityName: "ShortMovie")
    }

    @NSManaged public var poster_path: String?
    @NSManaged public var movie_id: NSNumber?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var backdrop_path: String?
    @NSManaged public var release_year: String?
    @NSManaged public var vote_average: NSNumber?

}
