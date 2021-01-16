//
//  Car+CoreDataClass.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 29/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Car)
public class Car: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(dateTime, forKey: .dateTime)
            try container.encode(ingress, forKey: .ingress)
            try container.encode(image, forKey: .image)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int64.self, forKey: .id)
            title = try values.decode(String.self, forKey: .title)
            dateTime = try values.decode(String.self, forKey: .dateTime)
            ingress = try values.decode(String.self, forKey: .ingress)
            image = try values.decode(String.self, forKey: .image)
        } catch {
            print ("error")
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case dateTime
        case ingress
        case image
    }

}
