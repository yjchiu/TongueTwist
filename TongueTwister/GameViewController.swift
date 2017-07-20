//
//  ViewController.swift
//  TongueTwister
//
//  Created by Yi-Jui, Chiu on 19/07/2017.
//  Copyright © 2017 AaronChiu. All rights reserved.
//

import UIKit
import SpeechToTextV1
import AVFoundation
import CoreData

class GameViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var player : User?
    
    var tongueTwisters  = [NSDictionary]()
    
    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false
    
    var topicCount = 0
    
    var score:Int = 0
    var totalScore : Int = 0
    var currentPoints:Double = 0.0
    var correct = false
    var userResults = ""
    
    
    
    
    var timer = Timer()
    @IBOutlet weak var timerLabel: UILabel!
    var sec = 30
    

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var tongueTwisterTopicTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var microphoneBtn: UIButton!
    
    @IBAction func microphoneBtnPressed(_ sender: UIButton) {
        streamMicrophoneBasic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        speechToTextSession = SpeechToTextSession(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        
        fetchUser()
        userLabel.text = "Hi, " + (player?.username)!
        scoreLabel.text = "Score: " + String(describing: (player?.score)!)
        timerLabel.text = "0:\(sec)"
        fetchAllTongueTwisters()
        
    }
    
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if topicCount < tongueTwisters.count-1 {
            topicCount += 1
        }else{
            topicCount = 0
        }
        
        let firstTongueTwister = tongueTwisters[topicCount]
        let content = firstTongueTwister["content"] as? NSArray
        tongueTwisterTopicTextView.text = content?[0] as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func streamMicrophoneBasic() {
        if !isStreaming {
            
            // update state
            microphoneBtn.setTitle("Stop", for: .normal)
            isStreaming = true
            startTimer()
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                self.textView.text = results.bestTranscript
                self.userResults = results.bestTranscript.lowercased()
            }
            
        } else {
            
            // update state
            microphoneBtn.setTitle("Start", for: .normal)
            isStreaming = false
            stopTimer()
            
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
            
            checkWords()
        }
    }
    
    func fetchUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do{
            let result =  try context.fetch(request)
            player = result.last as? User
            print("GameViewController fetchUser func ", player!)
            
        }catch{
            print("\(error)")
        }
    }
    
    
    func fetchAllTongueTwisters(){
    
        TongueTwistrModel.getAllTongueTwisters(completionHandler: {
            data, response, error in
            do{
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                    print("fetchAllTongueTwisters in DIDLOAD")
                    print("ALL Twisters: ", jsonResult)
                    self.tongueTwisters = jsonResult
                }
                DispatchQueue.main.async {
                    self.tongueTwisters.shuffle()
                    print("Shuffled: ", self.tongueTwisters)
                    let firstTongueTwister = self.tongueTwisters[0]
                    let content = firstTongueTwister["content"] as? NSArray
                    self.tongueTwisterTopicTextView.text = content?[0] as? String
                    
                    
                    
                }
                
            }catch{
            }
            
        })
    }
    
    
    func checkWords(){
        let twistDict = tongueTwisters[topicCount]
        let content = twistDict["content"] as? NSArray
        let twist = (content?[0] as? String)?.lowercased().components(separatedBy: " ")
        
//        let twist = tongueTwisters[topicCount].lowercased().components(separatedBy: " ")
//        print("Twister: \(twist)")
        var userWords = userResults.components(separatedBy: " ")
        userWords.remove(at: 0)
        userWords.remove(at: userWords.count-1)
        print("User's words: \(userWords)")
        var wordCount = 0
        var count = 0
        if userWords.count > (twist?.count)! {
            count = (twist?.count)!
        } else {
            count = userWords.count
        }
        for i in 0..<count {
//            print("Twist:\(twist?[i])")
            print("User: \(userWords[i])")
            if twist?[i] == userWords[i] {
                
                currentPoints = Double(100/twist!.count)
                score += Int(round(currentPoints))
                totalScore += score
                print(score)
                
            }
            wordCount += 1
        }
        
        scoreLabel.text = "Score: \(score)/100"
        score = 0
    
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.timerCounter()
        })
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func timerCounter(){
        if sec > 1{
            sec -= 1
            if sec < 10{
                self.timerLabel.text = "0:0\(sec)"
            }else{
                self.timerLabel.text = "0:\(sec)"
            }
        }else{
            self.timerLabel.text = "0:0\(0)"
            self.speechToText.stopRecognizeMicrophone()
            let alert = UIAlertController(title: "Game Over", message: "Your finals score is here", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
//                print("TOTAL: ", self.totalScore)
                self.updateUser(username: (self.player?.username)!, score: self.totalScore)
            
            })
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
            timer.invalidate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromGameToScoreSegue" {
            let navController =  segue.destination as! UINavigationController
            _ = navController.topViewController as! ScoreBoardTableViewController
        }
    }
    
    func updateUser(username: String, score:Int){
        TongueTwistrModel.updateUser(username: username, score: score, completionHandler: {
            data, response, error in
            print(data ?? "", response ?? "", error ?? "")
        
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "fromGameToScoreSegue", sender: self )
            }
        })
    }


}

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

