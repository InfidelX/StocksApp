//
//  DatabaseService.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 18.4.22.
//

import Foundation
import CoreData

protocol DatabaseService {
    func save(stock: Stock)
    func delete(stock: Stock)
    func getStocks() -> [Stock]?
}

enum StoreResult {
    case contains
    case success
    case failure
}

class DBManager: DatabaseService  {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StocksApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: - Core Data Operations
extension DBManager {

    func save(stock: Stock) {
        let context = persistentContainer.viewContext
        let localStock = CDStock(context: context)

        localStock.companyName = stock.companyName
        localStock.marketCap = stock.marketCap ?? 0
        localStock.symbol = stock.symbol
        
        saveContext()
    }
    
    func delete(stock: Stock) {
        
    }
    
    func getStocks() -> [Stock]? {
        // Create a fetch request for a specific Entity type
        let fetchRequest: NSFetchRequest<CDStock>
        fetchRequest = CDStock.fetchRequest()

        // Get a reference to a NSManagedObjectContext
        let context = persistentContainer.viewContext

        
        // Fetch all objects of one Entity type
        do {
            let objects = try context.fetch(fetchRequest)
            print("core data objects: \(objects.count)")
            return convertStocks(objects: objects)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}

//MARK: - Model Conversions
extension DBManager {
 
    func convertStocks(objects: [CDStock]) -> [Stock] {
        var result =  [Stock]()
        
        for item in objects {
            let stock = Stock(companyName: item.companyName, marketCap: item.marketCap, symbol: item.symbol)
            result.append(stock)
        }
        
        return result
    }
}
