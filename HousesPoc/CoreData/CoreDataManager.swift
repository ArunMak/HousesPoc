//
//  CoreDataManager.swift
//  HousesPoc
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2018 ArunMak. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HousesPoc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Save
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   // MARK: Insert
    func insertHouse(name: String, id : Int16, description : String, favourite : Bool ,image : String)->Houses? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Houses",
                                                in: managedContext)!
        let house = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        house.setValue(name, forKeyPath: "houseName")
        house.setValue(id, forKeyPath: "houseId")
        house.setValue(description, forKeyPath: "houseDesc")
        house.setValue(image, forKeyPath: "houseImage")
        house.setValue(favourite, forKeyPath: "favourite")
        do {
            try managedContext.save()
            return house as? Houses
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    // MARK: Update
    func update(name: String, id : Int16, description : String, image : String, favourite : Bool, house : Houses) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            house.setValue(name, forKey: "houseName")
            house.setValue(id, forKey: "houseId")
            house.setValue(description, forKey: "houseDesc")
            house.setValue(image, forKey: "houseImage")
            house.setValue(favourite, forKey: "favourite")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print("Error with request: \(error)")
            }
            
        }
    }
    
  // MARK: Fetch All data
    func fetchAllHouses() -> [Houses]?{
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Houses")
        do {
            let home = try managedContext.fetch(fetchRequest)
            return home as? [Houses]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: Fetch Favourites
    func fetchFavourites()-> [Houses]? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Houses")
      
        let predicate = NSPredicate(format: "favourite = \(NSNumber(value:true))")
        
        fetchRequest.predicate = predicate
        
        do {
            
            let home = try managedContext.fetch(fetchRequest)
            return home as? [Houses]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
}

