//
//  Database.swift
//  url session
//
//  Created by Ramy Ashraf on 14/05/2023.
//

import Foundation
import CoreData

final class Database {
    
    private let id = "id"
    private let name = "employee_name"
    private let salary = "employee_salary"
    private let age = "employee_age"
    private static var instance:Database? = nil
    private var context: NSManagedObjectContext
    private init(context: NSManagedObjectContext){
        self.context = context
    }
    
    class func getInstance(_ context: NSManagedObjectContext) -> Database {
        guard let db = instance else {
            return Database(context: context)
        }
        return db
    }
    
    func insert(_ employee: Employee) {
        let entity = NSEntityDescription.entity(forEntityName: "Employees", in: context)
        
        let emp = NSManagedObject(entity: entity!, insertInto: context)
        emp.setValue(employee.id ?? -1, forKey: id)
        emp.setValue(employee.employee_name ?? "N/A", forKey: name)
        emp.setValue(employee.employee_salary ?? 0, forKey: salary)
        emp.setValue(employee.employee_age ?? 0, forKey: age)
        print(employee.employee_name!)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func selectAll() -> Array<Employee> {
        var employees = Array<Employee>()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employees")
        do {
            let emps = try context.fetch(fetchRequest)
            for emp in emps {
                employees.append(Employee(id: emp.value(forKey: id) as? Int, employee_name: emp.value(forKey: name) as? String, employee_salary: emp.value(forKey: salary) as? Int, employee_age: emp.value(forKey: age) as? Int))
                print(emp.value(forKey: name) as! String)
            }
            return employees
        } catch let error as NSError {
            print(error.localizedDescription)
            return employees
        }
    }
    
    func update(employee: Employee) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        fetchRequest.predicate = NSPredicate(format: "id == %d", (employee.id!))
        do{
            let employees = try context.fetch(fetchRequest) as! [NSManagedObject]
            employees[0].setValue(employee.employee_name, forKey: name)
            employees[0].setValue(employee.employee_salary, forKey: salary)
            employees[0].setValue(employee.employee_age, forKey: age)
            try context.save()
        } catch {
            print("Couldnt save Employee!")
        }
    }
    
    
    
    func remove(_ employee: Employee) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        fetchRequest.predicate = NSPredicate(format: "id == %id", employee.id!)
        do {
            let employees = try context.fetch(fetchRequest) as! [NSManagedObject]
            for emp in employees {
                context.delete(emp)
            }
            try context.save()
        } catch {
            print("Error deleting Employee with id \(employee.id!)")
        }
    }
    
    func saveEmployees(_ employees: [Employee]){
        for employee in employees{
            self.insert(employee)
        }
    }
}
