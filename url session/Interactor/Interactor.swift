//
//  Interactor.swift
//  url session
//
//  Created by Ramy Ashraf on 23/05/2023.
//

import Foundation
import Reachability

class Interactor: InteractorProtocol {
    
    private var database: Database
    private var api: EmployeeAPI
    private weak var presenter: EmployeesPresenter?
    
    init(database: Database, api: EmployeeAPI, presenter: EmployeesPresenter){
        self.database = database
        self.api = api
        self.presenter = presenter
    }

    func fetchEmployees() {
        do {
            let reachability = try Reachability()
            if reachability.connection == .unavailable /*true*/ {
                presenter?.employeesFetched(database.selectAll())
            } else {
                api.getEmployeesFromAPI { [weak self] data in
                    self?.presenter?.employeesFetched(data)
                }
            }
        } catch {
            print("couldnt create reachability instance")
        }
    }
    
    func saveEmployee(_ employee: Employee) {
        database.insert(employee)
        presenter?.employeeSaved(employee)
    }
    
    func deleteEmployee(index: Int) {
        database.remove((presenter?.employees[index])!)
        presenter?.employeeDeleted(at: index)
    }

}
