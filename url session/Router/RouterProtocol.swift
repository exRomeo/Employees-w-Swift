//
//  RouterProtocol.swift
//  url session
//
//  Created by Ramy Ashraf on 23/05/2023.
//

import Foundation

protocol RouterProtocol {
    func navigateToAddScreen()
    func navigateToDetailsScreen(with employee: Employee)
    func dismissScreen()
}
