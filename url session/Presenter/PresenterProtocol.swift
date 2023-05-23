//
//  PresenterProtocol.swift
//  url session
//
//  Created by Ramy Ashraf on 23/05/2023.
//

import Foundation

protocol PresenterProtocol {
    func viewDidLoad()
    
    func initialize(database: Database, api:EmployeeAPI, router: Router, view: View)
    
    func employeesFetched(_ employees: [Employee])
    
    func employeeSaved(_ employee: Employee)
    
    func employeeDeleted(at index:Int)
    
    func navigateToAddScreen()
        
    func navigateToDetailsScreen(with employee: Employee)
    
    func dismissScreen()
    
    
    func saveEmployee(_ employee: Employee)
    
    func deleteEmployee(index: Int)
    
    func getEmployees()
}
