//
//  EmployeesPresenter.swift
//  url session
//
//  Created by Ramy Ashraf on 21/05/2023.
//

import Foundation
import Reachability

class EmployeesPresenter: PresenterProtocol {
    weak var view: View!
    var employees = [Employee]()
    var interactor: InteractorProtocol!
    var router: RouterProtocol!
    

    
    func viewDidLoad(){
        getEmployees()
    }
    
    func initialize(database: Database, api:EmployeeAPI, router: Router, view: View){
        self.view = view
        self.router = router
        self.interactor = Interactor(database: database, api: api, presenter: self)
    }
    
    func employeesFetched(_ employees: [Employee]){
        self.employees = employees
        view.renderData()
    }
    
    func employeeSaved(_ employee: Employee){
        employees.append(employee)
        view.renderData()
    }
    
    func employeeDeleted(at index:Int){
        employees.remove(at: index)
    }
    
    func navigateToAddScreen(){
        router.navigateToAddScreen()
    }
    
    func navigateToDetailsScreen(with employee: Employee){
        router.navigateToDetailsScreen(with: employee)
    }
    
    func dismissScreen(){
        router.dismissScreen()
    }
    
    
    func saveEmployee(_ employee: Employee){
        interactor.saveEmployee(employee)
    }
    
    func deleteEmployee(index: Int){
        interactor.deleteEmployee(index: index)
    }
    
    func getEmployees(){
        interactor.fetchEmployees()
    }
    
}
