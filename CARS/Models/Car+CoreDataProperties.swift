//
//  Car+CoreDataProperties.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 29/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var dateTime: String?
    @NSManaged public var ingress: String?
    @NSManaged public var image: String?

}
