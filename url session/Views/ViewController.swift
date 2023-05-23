//
//  ViewController.swift
//  url session
//
//  Created by Ramy Ashraf on 11/05/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmployeeDelegate, View {

    @IBOutlet weak var tableView: UITableView!
    let networkIndicatior = UIActivityIndicatorView(style: .large)
    
    var context: NSManagedObjectContext!
    
    var presenter: EmployeesPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(toAddEmployee))
        
        networkIndicatior.color = .blue
        networkIndicatior.center = view.center
        networkIndicatior.startAnimating()
        view.addSubview(networkIndicatior)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        presenter = EmployeesPresenter()
    
        presenter.initialize(database: Database.getInstance(context), api: EmployeeAPI.instance, router: Router(viewController: self), view: self)
        presenter.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = (presenter.employees[indexPath.row].employee_name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.navigateToDetailsScreen(with: presenter.employees[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.deleteEmployee(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    

    
    @objc func toAddEmployee(){
        presenter.navigateToAddScreen()
    }
    
    func saveEmployee(employee: Employee) {
        presenter.saveEmployee(employee)
    }
    
    func renderData() {
        DispatchQueue.main.async {
            self.networkIndicatior.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

