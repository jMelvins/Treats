//
//  Offer+CoreDataProperties.swift
//  
//
//  Created by Vladislav Shilov on 24.07.17.
//
//

import Foundation
import CoreData


extension Offer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var url: String?
    @NSManaged public var weight: String?
    
    @NSManaged public var imageID: NSData?
    
}
