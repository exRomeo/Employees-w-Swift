//
//  EmployeeAPI.swift
//  url session
//
//  Created by Ramy Ashraf on 21/05/2023.
//

import Foundation

class EmployeeAPI {
    private let base_url = "https://dummy.restapiexample.com/api/v1/employees"
    
    static let instance = EmployeeAPI()
    private init(){}
    func getEmployeesFromAPI(onCompletion: @escaping ([Employee]) -> Void){
        // Do any additional setup after loading the view.
        let url = URL(string: base_url)
        
        let req = URLRequest(url: url!)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: req) {
            (data , response, error) in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(EmployeeModel.self, from: data)
                
                onCompletion(result.data ?? [Employee]())
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
