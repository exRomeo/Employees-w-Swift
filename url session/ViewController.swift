//
//  ViewController.swift
//  url session
//
//  Created by Ramy Ashraf on 11/05/2023.
//

import UIKit
import Reachability
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    let networkIndicatior = UIActivityIndicatorView(style: .large)
    var dataArray: Array<Dictionary<String, Any>> = Array()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        networkIndicatior.color = .blue
        networkIndicatior.center = view.center
        networkIndicatior.startAnimating()
        view.addSubview(networkIndicatior)
        do {
            let reachability = try Reachability()
            if reachability.connection == .unavailable {
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
    
    
    
    
//    
//    private let id = "id"
//    private let name = "employee_name"
//    private let salary = "employee_salary"
//    private let age = "employee_age"
//    
//    
//     func insert(_ employee: [String: Any]) {
//        let entity = NSEntityDescription.entity(forEntityName: "Employees", in: context!)
//        
//        let emp = NSManagedObject(entity: entity!, insertInto: context)
//        emp.setValue(employee[id] as! Int, forKey: id)
//        emp.setValue(employee[name] as! String, forKey: name)
//        emp.setValue(employee[salary] as! Int, forKey: salary)
//        emp.setValue(employee[age] as! Int, forKey: age)
//        print(employee[name] as! String)
//        do {
//            try context?.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//     func select() -> Array<Dictionary<String, Any>> {
//        var employees = Array<Dictionary<String, Any>>()
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employees")
//        do {
//            let emps = try context?.fetch(fetchRequest)
//            for emp in emps! {
//                var employee: Dictionary<String, Any> = Dictionary()
//                employee[id] = emp.value(forKey: id) as! Int
//                employee[name] = emp.value(forKey: name) as! String
//                employee[salary] = emp.value(forKey: salary) as! Int
//                employee[age] = emp.value(forKey: age) as! Int
//                employees.append(employee)
//                
//                print(emp.value(forKey: name) as! String)
//            }
//            return employees
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            return employees
//        }
//    }
//    
//    
//    
//    func remove(_ employee: [String: Any]) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
//        fetchRequest.predicate = NSPredicate(format: "id == id", (employee[id] as! Int))
//        do {
//            let employees = try context?.fetch(fetchRequest) as! [NSManagedObject]
//            for emp in employees {
//                context?.delete(emp)
//            }
//            try context?.save()
//        } catch {
//            print("Error deleting Employee with id \(employee[id] as! Int)")
//        }
//    }
//    
//    func saveEmployees(_ employees: Array<[String: Any]>){
//        for employee in employees{
//            self.insert(employee)
//        }
//    }
}

