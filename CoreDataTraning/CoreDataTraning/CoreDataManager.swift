//
//  CoreDataManager.swift
//  CoreDataTraning
//
//  Created by Dev Miguel Chavez on 12/10/17.
//  Copyright © 2017 Dev Miguel Chavez. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() //will live forever as long as the application is still alive, and its properties will too
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
    
    func handleReset() -> Bool {
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch let deleteErr {
            print("Failed to delete objects from Core Data:", deleteErr)
            return false
        }
    }
    
    func createEmployee(employeeName: String) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return (employee, nil)
        } catch let saveErr {
            print("Failed to create employee:", saveErr)
            return (nil, saveErr)
        }
    }
}


