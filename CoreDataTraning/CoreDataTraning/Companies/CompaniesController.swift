//
//  CompaniesController.swift
//  CoreDataTraning
//
//  Created by Dev Miguel Chavez on 12/10/17.
//  Copyright © 2017 Dev Miguel Chavez. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController{
    
    var companies = [Company]()
    
    @objc private func doWork() {
        print("de work")
        // GCD - Grand Central Dispatch
        //DispatchQueue.global(qos: .background).async {
        //}
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...10).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                self.companies = CoreDataManager.shared.fetchCompanies()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let err {
                print("Failed to save:", err)
            }
            
        })
    }
    @objc private func doUpdates() {
        print("do Updates")
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
        
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "A: \(company.name ?? "")"
                })
                do {
                    try backgroundContext.save()
                    
                } catch let err {
                    print("Failed to save:", err)
                }
                
            } catch let err {
                print("Failed to fetch",err)
            }
            
        })
            
    }
    
    @objc private func doNestedUpdates() {
        print("do Nested Updates")
        
        DispatchQueue.global(qos: .background).async {
            //we will try to perform our updates
            
            // we will first contruct a custom MOC
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // excute updates on pricateContext noq
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies =  try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "M: \(company.name ?? "")"
                })
                do {
                    try privateContext.save()
                    
                    //after save succeds
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                            
                        } catch let saveErr {
                            print("Failed to save on main context", saveErr)
                        }
                    }
                    
                } catch let saveErr{
                    print ("Failed to save on private context", saveErr)
                }
            } catch let err {
                print("Failed to fetch on private context:", err)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        if (CoreDataManager.shared.handleReset()) {
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        }
    }
     
    @objc private func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true, completion: nil)
    }
}

