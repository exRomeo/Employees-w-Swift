//
//  InteractorProtocol.swift
//  url session
//
//  Created by Ramy Ashraf on 23/05/2023.
//

import Foundation

protocol InteractorProtocol {

    func fetchEmployees()
    func saveEmployee(_ employee: Employee)
    func deleteEmployee(index: Int)
}
