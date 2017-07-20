//
//  ScoreBoardTableViewController.swift
//  TongueTwister
//
//  Created by Yi-Jui, Chiu on 19/07/2017.
//  Copyright © 2017 AaronChiu. All rights reserved.
//

import UIKit

class ScoreBoardTableViewController: UITableViewController {
    
    var users = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        cell.nameLabel.text = users[indexPath.row]["username"] as? String
        cell.scoreLabel.text = "Score: " + String(describing: (users[indexPath.row]["score"] as? Int)!)

        return cell
    }
    
    
        func fetchAllUsers(){
    
            TongueTwistrModel.getAllUsers(completionHandler: {
                data, response, error in
                do{
    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                        print("fetchALL in DIDLOAD")
                        print(jsonResult)
                        self.users = jsonResult
                    }
    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
    
                }catch{
                }
    
            
            })
        }
 

   

}
