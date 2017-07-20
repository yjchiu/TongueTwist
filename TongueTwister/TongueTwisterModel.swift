//
//  TongueTwisterModel.swift
//  TongueTwister
//
//  Created by Yi-Jui, Chiu on 19/07/2017.
//  Copyright © 2017 AaronChiu. All rights reserved.
//

import Foundation


class TongueTwistrModel {
    
    static func getAllUsers(completionHandler: @escaping (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        
        // Specify the url that we will be sending the GET Request to
        
        
        let url = URL(string: "http://13.59.99.34/show_user_info")
        
        // Create a URLSession to handle the request tasks
        let session = URLSession.shared
        // Create a "data task" which will request some data from a URL and then run the completion handler that we are passing into the getAllPeople function itself
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
        
        
    }
    
    static func addUser(username : String, score: Int, completionHandler : @escaping  (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://13.59.99.34/add_user") {
            
            var request = URLRequest(url : urlToReq)
            
            request.httpMethod = "POST"
            
            let bodyData = "username=\(username)&score=\(score)"
            
            request.httpBody = bodyData.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler : completionHandler)
            
            task.resume()
        }
    }
    
    static func updateUser(username : String , score : Int, completionHandler : @escaping (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        if let urlToReq = URL(string: "http://13.59.99.34/update_user_score") {
            
            var request = URLRequest(url : urlToReq)
            
            request.httpMethod = "POST"
            
            let bodyData = "username=\(username)&score=\(score)"
            
            request.httpBody = bodyData.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler : completionHandler)
            
            task.resume()
        }
        
    }
    
    
    
    static func getAllTongueTwisters(completionHandler: @escaping (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        
        // Specify the url that we will be sending the GET Request to
        
        
        let url = URL(string: "http://13.59.99.34/show_tongue_twisters")
        
        // Create a URLSession to handle the request tasks
        let session = URLSession.shared
        // Create a "data task" which will request some data from a URL and then run the completion handler that we are passing into the getAllPeople function itself
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
        
        
    }
    
    


    

    
}
