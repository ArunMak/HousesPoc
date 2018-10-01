//
//  Houses+CoreDataProperties.swift
//  HousesPoc
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2018 ArunMak. All rights reserved.
//

import Foundation
import CoreData


extension Houses {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Houses> {
        return NSFetchRequest<Houses>(entityName: "Houses")
    }
    
    @NSManaged public var houseName: String?
    @NSManaged public var houseId: Int16
    @NSManaged public var houseDesc: String?
    @NSManaged public var houseImage: String?
    @NSManaged public var favourite: Bool
   
    
    
    
}
