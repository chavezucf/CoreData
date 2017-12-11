//
//  EmployeesController.swift
//  CoreDataTraning
//
//  Created by Dev Miguel Chavez on 12/10/17.
//  Copyright © 2017 Dev Miguel Chavez. All rights reserved.
//

import UIKit
import CoreData
class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        let newIndexPath = IndexPath(row: employees.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        //tableView.reloadData()
    }
    
    
    var company: Company?
    
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(request)
            self.employees = employees
        } catch let err {
            print("Failed to fetch Employees:", err)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let employee = employees[indexPath.row]
        
        cell.textLabel?.text = employee.name
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    let cellID = "cellllID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()
    }
    
    @objc private func handleAdd() {
        print("Trying to add")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
}
