//
//  FeedbackViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/23/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedbackViewController: UIViewController {
    var ref: DatabaseReference!



    override func viewDidLoad() {
        super.viewDidLoad()
        promptLabel.text = "Send Team Eight: Feedback, Feature Requests, Bug Reports, etc.  \nPlease be specific 🙏"

    }
    
    @IBAction func sendAction(_ sender: Any) {
        // check if there is any feedback in the textbox
        if feedbackTV.text == "" {
            Agrippa.popUpAlertNoImage(title: "No Text", message: "To submit feedback you need to write something in the textfield.", vc: self)
        } else {

            // check if they've sent something, if they haven't add a default and set to 1...
            if Agrippa.defaultexists(forKey: "sends") == true {
                var sends = UserDefaults.standard.integer(forKey: "sends")
                sends += 1
                print("sends: \(sends)")
                UserDefaults.standard.set(sends, forKey: "sends")
                
            } else {
                UserDefaults.standard.set(1, forKey: "sends")
            }
            
            // just to be safe, checking to make sure the default is there again, tho it should be from above
            // sends, unless they've sent too many DDOS baby!
            if Agrippa.defaultexists(forKey: "sends") == true {
                var sends = UserDefaults.standard.integer(forKey: "sends")
                if sends > 12 {
                    print("too many!")
                    Agrippa.popUpAlertNoImage(title: "Maximum Reached", message: "Thank you very much for your feedback, however you have already sent too many.", vc: self)

                    
                } else {
                    ref = Database.database().reference()
                    print(ref)
                    
                    var userID = randomString(length: 9)
                    print(userID)
                    ref!.child("feedback").child(userID).setValue(["input": feedbackTV.text])
                    Agrippa.popUpAlertWithCompletion(title: "Sent!", message: "Thank you very much, your feedback means a lot to us!", vc: self) {
                        print("pop pop pop")
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                    
                }
            }
            
        }
    }
    
    
    @IBAction func nevermindAction(_ sender: Any) {
        feedbackTV.text = ""
    }
    
    
    
    @IBOutlet weak var feedbackTV: UITextView!
    
    
    @IBOutlet weak var promptLabel: UILabel!
    
    
        //function can be placed in View Contoller, such that the keyboard will disappear when you tap outside of the keyboard space
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
            // This function makes it so that if you tap outside of the keyboard it will disappear.
        }
    

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
