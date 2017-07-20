//
//  UserViewController.swift
//  TongueTwister
//
//  Created by Yi-Jui, Chiu on 19/07/2017.
//  Copyright © 2017 AaronChiu. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController, UITextFieldDelegate {
    
//    var users = [NSDictionary]()

    @IBOutlet weak var playerTextField: UITextField!
    @IBOutlet weak var playerExistedLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerExistedLabel.isHidden = true
        playerTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerTextField.resignFirstResponder()
        return true
    }

    @IBAction func startBtnPressed(_ sender: UIButton) {
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.username = playerTextField.text
        user.score = 0
        
        
        //add to CoreData
        do {
            try context.save()
        }catch {
            print("can not add item, error: ", error)
        }
        
        
        //add to DB
        addUser()
        
        performSegue(withIdentifier: "GameStartSegue", sender: sender)
    }
    
    
    @IBAction func scoreBoardBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "scoreBoardSegue", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameStartSegue" {
            _ =  segue.destination as! GameViewController
        }else {
            let navController =  segue.destination as! UINavigationController
            _ = navController.topViewController as! ScoreBoardTableViewController
        }
    }
    
    
    
    func addUser(){
        TongueTwistrModel.addUser(username: playerTextField.text!, score: 0, completionHandler: {
            data, response, error in
            do{
            
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    print("add User into DB: ", jsonResult)
                }
            }catch{
            }
        
        
        })
    }
    
    @IBAction func unwindSegueFunc(segue : UIStoryboardSegue){
        playerTextField.text = "" 
    }

    
    
    
//    func fetchAllUsers(){
//    
//        TongueTwistrModel.getAllUsers(completionHandler: {
//            data, response, error in
//            do{
//                
//                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
//                    print("fetchALL in DIDLOAD")
//                    print(jsonResult)
//                    
//                    //
//                    
//                    self.users = jsonResult
//                }
//
//                //                DispatchQueue.main.async {
//                
//                //                }
//                
//            }catch{
//            }
//
//        
//        })
//    }
    
    
    

}
