//
//  DatabaseManager.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 29/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import CoreData

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    var cars = [Car]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CARS")
        
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    func sync() {
        delete()
        saveContext()
    }
    
    // save changes from memory back to the database (from memory)
    // viewContext is checked for changes
    // then saves are comitted to the store
    private func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    private func delete() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            let result = try persistentContainer.viewContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [persistentContainer.viewContext])
        } catch {
            print("error executing fetch request: \(error)")
        }
    }
    
    func loadFromDB() -> [Car] {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            // fetch is performed on the NSManagedObjectContext
            cars = try persistentContainer.viewContext.fetch(request)
            print("Got \(cars.count) cars from DB")
        } catch {
            print("Fetch failed")
        }
        return cars
    }
    
    
    
}

