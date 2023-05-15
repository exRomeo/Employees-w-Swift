//
//  Database.swift
//  url session
//
//  Created by Ramy Ashraf on 14/05/2023.
//

import Foundation
import CoreData

final class Database {
    
    private static let id = "id"
    private static let name = "employee_name"
    private static let salary = "employee_salary"
    private static let age = "employee_age"
    
    private init(){}
    
    
    class func insert(_ employee: [String: Any], into context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Employees", in: context)
        
        let emp = NSManagedObject(entity: entity!, insertInto: context)
        emp.setValue(employee[id] as! Int, forKey: id)
        emp.setValue(employee[name] as! String, forKey: name)
        emp.setValue(employee[salary] as! Int, forKey: salary)
        emp.setValue(employee[age] as! Int, forKey: age)
        print(employee[name] as! String)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    class func select(from context: NSManagedObjectContext) -> Array<Dictionary<String, Any>> {
        var employees = Array<Dictionary<String, Any>>()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employees")
        do {
            let emps = try context.fetch(fetchRequest)
            for emp in emps {
                var employee: Dictionary<String, Any> = Dictionary()
                employee[id] = emp.value(forKey: id) as! Int
                employee[name] = emp.value(forKey: name) as! String
                employee[salary] = emp.value(forKey: salary) as! Int
                employee[age] = emp.value(forKey: age) as! Int
                employees.append(employee)
                
                print(emp.value(forKey: name) as! String)
            }
            return employees
        } catch let error as NSError {
            print(error.localizedDescription)
            return employees
        }
    }
    
    class func update(from context: NSManagedObjectContext, employee: [String: Any]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        fetchRequest.predicate = NSPredicate(format: "id == %d", (employee[id] as! Int))
        do{
            let employees = try context.fetch(fetchRequest) as! [NSManagedObject]
            employees[0].setValue(employee[name], forKey: name)
            employees[0].setValue(employee[salary], forKey: salary)
            employees[0].setValue(employee[age], forKey: age)
            try context.save()
        } catch {
            print("Couldnt save Employee!")
        }
    }
    
    
    
    class func remove(_ employee: [String: Any], from context:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        fetchRequest.predicate = NSPredicate(format: "id == %id", (employee[id] as! Int))
        do {
            let employees = try context.fetch(fetchRequest) as! [NSManagedObject]
            for emp in employees {
                context.delete(emp)
            }
            try context.save()
        } catch {
            print("Error deleting Employee with id \(employee[id] as! Int)")
        }
    }
    
    class func saveEmployees(_ employees: Array<[String: Any]>, into context: NSManagedObjectContext){
        for employee in employees{
            self.insert(employee, into: context)
        }
    }
}
