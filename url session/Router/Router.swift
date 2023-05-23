//
//  Router.swift
//  url session
//
//  Created by Ramy Ashraf on 23/05/2023.
//

import Foundation
import UIKit
class Router: RouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateToAddScreen(){
        guard let avc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addScreen") as! AddViewController? else {
            return
        }
        avc.employeeDelegate = (viewController as! EmployeeDelegate)
        viewController?.navigationController?.pushViewController(avc, animated: true)
    }
    
    func navigateToDetailsScreen(with employee: Employee) {
        guard let dtvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsScreen") as! DetailsViewController? else {
            return
        }
        dtvc.employee = employee
        viewController?.navigationController?.pushViewController(dtvc, animated: true)
    }
    
    func dismissScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
