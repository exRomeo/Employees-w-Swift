//
//  DetailsViewController.swift
//  url session
//
//  Created by Ramy Ashraf on 11/05/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    var employee:Employee = Employee(id: 0, employee_name: "N/A", employee_salary: 0, employee_age: 0)
    @IBOutlet weak var employee_id: UILabel!
    @IBOutlet weak var employee_name: UILabel!
    @IBOutlet weak var employee_salary: UILabel!
    @IBOutlet weak var employee_age: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        employee_id.text = String(employee.id)
        employee_name.text = employee.employee_name
        employee_salary.text = String(employee.employee_salary)
        employee_age.text = String(employee.employee_age)
        
        detailsLabel.text = NSLocalizedString("detailsLabel", comment: "")
        idLabel.text = NSLocalizedString("idLabel", comment: "")
        nameLabel.text = NSLocalizedString("nameLabel", comment: "")
        salaryLabel.text = NSLocalizedString("salaryLabel", comment: "")
        ageLabel.text = NSLocalizedString("ageLabel", comment: "")
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
