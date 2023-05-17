//
//  ViewController.swift
//  url session
//
//  Created by Ramy Ashraf on 11/05/2023.
//

import UIKit
import Reachability
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    let networkIndicatior = UIActivityIndicatorView(style: .large)
    var dataArray: Array<Dictionary<String, Any>> = Array()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(toAddEmployee))
        
        networkIndicatior.color = .blue
        networkIndicatior.center = view.center
        networkIndicatior.startAnimating()
        view.addSubview(networkIndicatior)
        do {
            let reachability = try Reachability()
            if /*reachability.connection == .unavailable*/ true {
                getEmployeesFromDatabase()
            } else {
                getEmployeesFromAPI()
            }
        } catch {
            print("couldnt create reachability instance")
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = (dataArray[indexPath.row]["employee_name"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emp:Employee =
        Employee(id: (dataArray[indexPath.row]["id"] as! Int),
                 employee_name: (dataArray[indexPath.row]["employee_name"] as! String),
                 employee_salary: (dataArray[indexPath.row]["employee_salary"] as! Int),
                 employee_age: (dataArray[indexPath.row]["employee_age"] as! Int))
        
        let dtvc = storyboard?.instantiateViewController(withIdentifier: "detailsScreen") as! DetailsViewController
        dtvc.employee = emp
        
        navigationController?.pushViewController(dtvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        Database.remove(dataArray[indexPath.row], from: context!)
        dataArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    func getEmployeesFromAPI(){
        // Do any additional setup after loading the view.
        let url = URL(string: "https://dummy.restapiexample.com/api/v1/employees")
        
        let req = URLRequest(url: url!)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: req) {
            (data , response, error) in
            do {
                //search for try! and try?
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
                self.dataArray = json["data"] as! Array<Dictionary<String, Any>>
                Database.saveEmployees(self.dataArray, into: self.context!)
                DispatchQueue.main.async {

                    self.networkIndicatior.stopAnimating()
                    self.tableView.reloadData()
                    
                }
            } catch {
               print(error)
            }
        }
        task.resume()
    }
    
    func getEmployeesFromDatabase(){
        dataArray = Database.select(from: context!)
        networkIndicatior.stopAnimating()
        tableView.reloadData()
    }
    
    @objc func toAddEmployee(){
        let avc = storyboard?.instantiateViewController(withIdentifier: "addScreen") as! AddViewController
        avc.employeeDelegate = self
        navigationController?.pushViewController(avc, animated: true)
    }
    
    func saveEmployee(employee: [String : Any]) {
        dataArray.append(employee)
        Database.insert(employee, into: context!)
        tableView.reloadData()
    }
}

