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
    
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var salaryField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveEmployee))
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func saveEmployee(){
        var empDict = Dictionary<String, Any>()
        
        if !idField.text!.isEmpty && !nameField.text!.isEmpty{
            empDict[id] = Int(idField.text ?? "0")
            empDict[name] = nameField.text ?? "N/A"
            empDict[salary] = Int(salaryField.text ?? "0")
            empDict[age] = Int(ageField.text ?? "0")
            employeeDelegate?.saveEmployee(employee: empDict)
            navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
