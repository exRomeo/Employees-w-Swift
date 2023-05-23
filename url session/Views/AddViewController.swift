//
//  AddViewController.swift
//  url session
//
//  Created by Ramy Ashraf on 15/05/2023.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    var employeeDelegate: EmployeeDelegate?
    
    private let id = "id"
    private let name = "employee_name"
    private let salary = "employee_salary"
    private let age = "employee_age"
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var salaryField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("saveButton", comment: ""), style: .plain, target: self, action: #selector(saveEmployee))
        
        // Do any additional setup after loading the view.
        addLabel.text = NSLocalizedString("addLabel", comment: "")
        nameLabel.text = NSLocalizedString("nameLabel", comment: "")
        salaryLabel.text = NSLocalizedString("salaryLabel", comment: "")
        ageLabel.text = NSLocalizedString("ageLabel", comment: "")
        idLabel.text = NSLocalizedString("idLabel", comment: "")
        
        idField.placeholder = NSLocalizedString("idLabel", comment: "")
        nameField.placeholder = NSLocalizedString("nameLabel", comment: "")
        salaryField.placeholder = NSLocalizedString("salaryLabel", comment: "")
        ageField.placeholder = NSLocalizedString("ageLabel", comment: "")
    }
    
    
    @objc func saveEmployee(){
        if !idField.text!.isEmpty && !nameField.text!.isEmpty{
            employeeDelegate?
                .saveEmployee(
                    employee: Employee(id: Int(idField.text ?? "0"),
                                       employee_name: nameField.text ?? "N/A",
                                       employee_salary: Int(salaryField.text ?? "0"),
                                       employee_age: Int(ageField.text ?? "0"))
                )
            navigationController?.popViewController(animated: true)
        }
    }
}
