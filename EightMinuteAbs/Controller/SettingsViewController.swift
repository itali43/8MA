//
//  SettingsViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/23/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
//    var products: [SKProduct] = []
    var itIsAirhorn = true

    
    func changeSoundValue(to: String, quietly: Bool) {
        print("changing Sound Value to: \(to)")
        if to == "Airhorn" {
            UserDefaults.standard.set(true, forKey: "isAirhorn")
            
            // UI Selection: change airhorn to blue background and cheering to white
            airhornBTN.backgroundColor = UIColor(named: "backgroundBlue")
            airhornBTN.setTitleColor(.white, for: .normal)
            cheeringBTN.backgroundColor = .white
            cheeringBTN.setTitleColor(UIColor(named: "backgroundBlue"), for: .normal)
            
            if quietly == true {
                print("shhhhh! Airhorn")
            } else {
            Sound.play(file: "AirHorn.wav")
            }

        }
        
        if to == "Cheering" {
            
            // UI Selection: change airhorn to blue background and cheering to white
            UserDefaults.standard.set(false, forKey: "isAirhorn")
            cheeringBTN.backgroundColor = UIColor(named: "backgroundBlue")
            cheeringBTN.setTitleColor(.white, for: .normal)
            airhornBTN.backgroundColor = .white
            airhornBTN.setTitleColor(UIColor(named: "backgroundBlue"), for: .normal)
            
            if quietly == true {
                print("shhhhh! Cheering")
            } else {
                Sound.play(file: "Cheering.wav")
            }


        }
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("view appearing")
//        if itIsAirhorn == true {
//            changeSoundValue(to: "Airhorn", quietly: true)
//        } else {
//            changeSoundValue(to: "Cheering", quietly: true)
//
//        }
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "isAirhorn") == true {
            print("airhorn time")
            changeSoundValue(to: "Airhorn", quietly: true)
        } else {
            print("cheering time")
            changeSoundValue(to: "Cheering", quietly: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if airhorn default doesn't exist, it is airhorn so make it so
        if Agrippa.defaultexists(forKey: "isAirhorn") == false {
            UserDefaults.standard.set(true, forKey: "isAirhorn")
            airhornBTN.backgroundColor = UIColor(named: "backgroundBlue")
            airhornBTN.setTitleColor(.white, for: .normal)
            cheeringBTN.backgroundColor = .white
            cheeringBTN.setTitleColor(UIColor(named: "backgroundBlue"), for: .normal)
            print("first time here huh..")
        } else {
            // airhorn default exists, user has been here before
            itIsAirhorn = UserDefaults.standard.bool(forKey: "isAirhorn")
            print("itIsAirhorn Exists, and was changed to: \(itIsAirhorn)")
        }

        // end viewdidload
    }
    
    
    
    
    
    
    @IBAction func memPurchaseAction(_ sender: Any) {
        
        performSegue(withIdentifier: "toPurchase", sender: nil)

    }
    
    @IBAction func giveFeedbackAction(_ sender: Any) {
        performSegue(withIdentifier: "toFeedback", sender: nil)
    }
    
    
    @IBOutlet weak var airhornBTN: UIButton!
    @IBAction func airhornAction(_ sender: Any) {
        changeSoundValue(to: "Airhorn", quietly: false)
    }
    
    @IBOutlet weak var cheeringBTN: UIButton!
    @IBAction func cheeringAction(_ sender: Any) {
        changeSoundValue(to: "Cheering", quietly: false)
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
