//
//  CreateEmployeeController.swift
//  CoreDataTraning
//
//  Created by Dev Miguel Chavez on 12/10/17.
//  Copyright © 2017 Dev Miguel Chavez. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        //enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "CreateEmployee"
        setupCancelButton()
        
        view.backgroundColor = .darkBlue
        
        setupUI()
        setupSaveButton(selector: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        print("save")
        guard let name = nameTextField.text else { return }
        let (employee, error) = CoreDataManager.shared.createEmployee(employeeName: name)
        if let error = error {
            //error modal
            print(error)
        } else {

            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: employee!)
            })
        }
        
    }
    
    private func setupUI() {
        
        _ = setupLightBlueBackground(height: 50)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }
    
}
