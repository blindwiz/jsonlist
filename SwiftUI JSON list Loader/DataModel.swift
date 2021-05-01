//
//  DataModel.swift
//  MyCoffee
//
//  Created by Juan Hernandez on 4/27/21.
import Foundation
import Combine

class DataModel {

    private var api_authentication_token = "$2y$10$FzSejH6Ow8.nbBtKSiUNge1z/Clx0rQHsESdosjJbyo3WaYP/z082"

    
    private   func request(body: Dictionary<String, Any>, handler: @escaping (Data) -> ()) -> Void {
        let Url = String(format: "https://prospero.rtitek.com/srv.php")
        let serviceUrl = URL(string: Url)!
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        
session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("*AUTH*: \(response)")
            } // end if response
//             if let data = data {
                handler(data!)
//             } // end if
        }.resume()
    } // end method auth2


func registerUser(first: String, last: String, display: String, zip: String, email: String, password: String, dob: String, tos: Bool, rootHandler: @escaping (CommonAPIReturn) -> ()) -> Void {

    let params = [
        "auth_token": self.api_authentication_token,
"action": "register",
"fname": first,
"lname": last,
"dname": display,
"email": email,
"password": password,
"zip": zip,
"dob": dob,
"tos": tos
    ] as [String: Any]
    

request(body: params) { (data) in
    let decoder = JSONDecoder()

    do {
        let                             commonReturn = try decoder.decode(CommonAPIReturn.self, from: data)
        if commonReturn.status == "SUCCESS" {
            print("Authentication:  Successful")
        rootHandler(commonReturn)
        } else {
            print("ERROR: could not authenticate.")
    rootHandler(commonReturn)
        }
        
    } catch {
        print(error.localizedDescription)
    } // end do

    
}
} // end funtion

public func authenticateLogin(email: String, password: String, rootHandler: @escaping (CommonAPIReturn) -> ()) -> Void {
    let params = [
        "auth_token": self.api_authentication_token,
        "action": "login",
        "email": email,
        "password": password
    ] as [String: Any]
    

    request(body: params) { (data) in
        let decoder = JSONDecoder()
    
        do {
//             print("*AUTH*: \(data.debugDescription)")
            
            let                             commonReturn = try decoder.decode(CommonAPIReturn.self, from: data)
            if commonReturn.status == "SUCCESS" {
                print("Authentication:  Successful")
            rootHandler(commonReturn)
            } else {
                print("ERROR: could not authenticate.")
        rootHandler(commonReturn)
            }
            
        } catch {
            print(error.localizedDescription)
        } // end do
    
            } // end closure
} // end function registerUser

    
 
    public func get_drinks_by_id(for id: Int, rootHandler: @escaping ([Drink]) -> ()) -> Void {
        // takes a customer's id as an argument.
        let params = [
            "auth_token": self.api_authentication_token,
            "action": "get_drinks_by_id",
            "id": id,
        ] as [String: Any]
        

        request(body: params) { (data)  in
            
            DispatchQueue.main.async {
                let decoder = JSONDecoder()

            do {
                print("*get_drinks_by_id*: \(data.debugDescription)")
                    
                let                             drinks = try decoder.decode([Drink].self, from: data)
                print("*get_drinks_by_id*: \(drinks)")
rootHandler(drinks)
            } catch {
            } // end do
            } // end async

            
        }
    } // end function get_drinks_by_id
   

} // end class

var defString = String(stringLiteral: "")
var defInt = -1
var defDouble  = -0.1

struct Drink: Codable, Identifiable {

var id = UUID()
    
    var name: String?
    var creator_id: Int?
    var bean: String?
        var drink_type: String?
    var temperature: String?
    var roast_level: String?
    var milk_kind: String?
    var milk_fat: String?
    var milk_state: String?
    var sugar: String?
    var creamer: String?
    var flavor1: String?
    var flavor2: String?
    var flavor3: String?
    var created_ts: String?
    var last_modified_ts: String?
    
} // end drink

    

struct CommonAPIReturn: Codable, CustomStringConvertible {
    
    var action: String?
    var status: String?
    var message: String?
    
    var description: String {
        
        return """
        action = \(action ?? defString), status = \(status ?? defString)
"""
    }
}

extension Dictionary {
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
}

