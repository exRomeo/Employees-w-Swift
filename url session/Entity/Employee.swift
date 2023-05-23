//
//  Employee.swift
//  url session
//
//  Created by Ramy Ashraf on 11/05/2023.
//

import Foundation

class Employee: Decodable {
    
    let id:Int?
    let employee_name: String?
    let employee_salary: Int?
    let employee_age: Int?
    
    init(id: Int?, employee_name: String?, employee_salary: Int?, employee_age: Int?) {
        self.id = id
        self.employee_name = employee_name
        self.employee_salary = employee_salary
        self.employee_age = employee_age
    }
    
}
