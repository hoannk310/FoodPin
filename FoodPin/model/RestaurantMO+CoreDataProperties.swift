//
//  RestaurantMO+CoreDataProperties.swift
//  FoodPin
//
//  Created by Apple on 11/12/20.
//
//

import Foundation
import CoreData


extension RestaurantMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantMO> {
        return NSFetchRequest<RestaurantMO>(entityName: "Restaurant")
    }

    @NSManaged public var image: Data?
    @NSManaged public var isVisited: Bool
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var rating: String?
    @NSManaged public var type: String?

}

extension RestaurantMO : Identifiable {

}
