//
//  Favourites+CoreDataProperties.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/11/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//
//

import Foundation
import CoreData


extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var backdrop_path: String?
    @NSManaged public var movie_id: NSNumber?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var title: String?
    @NSManaged public var timeOfAddition: NSDate?
    @NSManaged public var vote_average: NSNumber?
    @NSManaged public var release_year: String?

}
