//
//  Database.swift
//  url session
//
//  Created by Ramy Ashraf on 14/05/2023.
//

import Foundation
import SQLite3
class Database {
    
    private let id = "id"
    private let name = "employee_name"
    private let salary = "employee_salary"
    private let age = "employee_age"
    
    static var instance: Database = Database()
    private var db: OpaquePointer? = nil
    
    private init(){
        let file = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let path = file?.appendingPathComponent("employees_db.sqlite").relativePath
        
        print("file created at = \(path!)")
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("opened db")
            
            let createTableString =
                """
                CREATE TABLE IF NOT EXISTS Employees (
                \(id) INT PRIMARY KEY NOT NULL,
                \(name) CHAR (255),
                \(salary) INT NOT NULL,
                \(age) INT NOT NULL
                );
                """
            var createStatement: OpaquePointer?
            if sqlite3_prepare(db, createTableString, -1, &createStatement, nil) == SQLITE_OK {
                if sqlite3_step(createStatement) == SQLITE_DONE {
                    print("Employees Table Created")
                } else {
                    print("Employees table not created")
                }
            } else {
                print("Not Prepared!")
            }
        } else {
            print("Couldn't open file")
        }
    }
    
    
    func insert(_ employee: [String: Any]) {
        let insertString = "INSERT INTO Employees(\(id), \(name), \(salary), \(age)) VALUES(?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {

            let id: Int32 = Int32(employee[id] as! Int)
            let name: NSString = employee[name] as! NSString
            let salary: Int32 = Int32(employee[salary] as! Int)
            let age: Int32 = Int32(employee[age] as! Int)
            
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, salary)
            sqlite3_bind_int(insertStatement, 4, age)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("insertion success")

            } else {
                print("insertion failure")
            }
        } else {
            print("insert Statement not prepared")
        }
    }
    
    
    func select() -> Array<Dictionary<String, Any>> {
        var employees = Array<Dictionary<String, Any>>()
        let selectString = "SELECT * FROM Employees;"
        var selectStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectString, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                var employee: Dictionary<String, Any> = Dictionary()
                employee[id] = Int(sqlite3_column_int(selectStatement, 0))
                employee[name] = String(cString: sqlite3_column_text(selectStatement, 1))
                employee[salary] = Int(sqlite3_column_int(selectStatement, 2))
                employee[age] = Int(sqlite3_column_int(selectStatement, 3))
                employees.append(employee)
            }
        } else {
            print("select Statement not prepared")
        }
        return employees
    }
    
    
    
    func remove(employee: [String: Any]) {
        let employee_id = Int32(employee[id] as! Int)
        let deleteString = "DELETE FROM Employees WHERE \(id) = \(employee_id)"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Row Deleted")
            } else {
                print("Row Not Deleted")
            }
        } else {
            print("Delete Statement Not Prepared")
        }
    }
    
    func saveEmployees(employees: Array<[String: Any]>){
        for employee in employees{
            self.insert(employee)
        }
    }
}
