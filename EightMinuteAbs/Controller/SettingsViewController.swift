//
//  SettingsViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/23/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let workouts = ["Classic 8MA", "Twist and Shout", "Plethora O'Planks"]
    let workoutDetail = ["Random set of 20+ Ab exercises", "How many Russian Twists can one do?!?!.. 8 min worth.", "Planks alternating with other exercises"]
    
    @IBOutlet weak var workoutSelectionTable: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .white
        cell?.detailTextLabel?.textColor = .white
        cell?.contentView.backgroundColor = UIColor(named: "backgroundBlue")
        UserDefaults.standard.set(indexPath.row, forKey: "workout")


    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor(named: "backgroundBlue")
        cell?.detailTextLabel?.textColor = UIColor(named: "backgroundBlue")
        cell?.contentView.backgroundColor = .white
        UserDefaults.standard.set(indexPath.row, forKey: "workout")


    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
//        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell.textLabel?.text = workouts[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "backgroundBlue")
        cell.textLabel?.font = UIFont(name:"InterUI-Bold", size:17)
        
        cell.detailTextLabel?.text = workoutDetail[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor(named: "backgroundBlue")
        cell.detailTextLabel?.font = UIFont(name:"InterUI-Regular", size:12)
        

        
        return cell
    }
    
    
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
    
    
    
    
    @IBOutlet weak var blockerBTN: UIButton!
    @IBAction func blockerAction(_ sender: Any) {
        let msg =
        """
        Additional workout routines are available only to 8MA Members.  Proceed to membership signup and unlock tons of new workout routines and many more benefits!!
        """
        Agrippa.popUpAlertWithCompletion(title: "Members Only", message: msg, vc: self) {
            self.performSegue(withIdentifier: "toPurchase", sender: nil)
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
        
        // if not a member, disallow workout choice
        if Agrippa.defaultexists(forKey: "isMember") == true {
            
            if UserDefaults.standard.bool(forKey: "isMember") == true {
                // user is a member
                blockerBTN.isHidden = true
                print("user is a member, unblock workouts")
            } else {
                // user is not yet a member
                blockerBTN.isHidden = false
                print("user is NOT a member, keep workouts BLOCKED")

            }
            
        } else {
            UserDefaults.standard.set(false, forKey: "isMember")
        }
        
        // change sound switcher without making a noise
        if UserDefaults.standard.bool(forKey: "isAirhorn") == true {
            print("airhorn time")
            changeSoundValue(to: "Airhorn", quietly: true)
        } else {
            print("cheering time")
            changeSoundValue(to: "Cheering", quietly: true)
        }
        
        // choose workout
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if Agrippa.defaultexists(forKey: "workout") {
            // has been set, select according to what has been saved previously
            let num = UserDefaults.standard.integer(forKey: "workout")
            let index = IndexPath(row: num, section: 0)
            workoutSelectionTable.selectRow(at: index, animated: false, scrollPosition: .none)
            self.tableView(workoutSelectionTable, didSelectRowAt: index)
            print("preset to another workout than classic")
//            workoutSelectionTable.selectRow(at: index, animated: false, scrollPosition: .bottom)
//            self.tableView(self.tableView, didSelectRowAt: indexPath)

            
        } else {
        
            // default doesn't exist, must not have been set yet, so should be default classic 8MA
            UserDefaults.standard.set(0, forKey: "workout")
            // set selection to "classic"
            let num = UserDefaults.standard.integer(forKey: "workout")
            let index = IndexPath(row: num, section: 0)
            workoutSelectionTable.selectRow(at: index, animated: false, scrollPosition: .none)
            self.tableView(workoutSelectionTable, didSelectRowAt: index)

        }
        
        title = "Settings"
        
        // disable interaction with member button until purchased or not is determined
        self.memPurchaseBTN.isUserInteractionEnabled = false

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
        
        
        
        if Agrippa.defaultexists(forKey: "isMember") {
            if UserDefaults.standard.bool(forKey: "isMember") == true {
                self.memPurchaseBTN.setTitle("See Member Benefits", for: .normal)

            } else {
                self.memPurchaseBTN.setTitle("Upgrade and Get More!", for: .normal)

            }
            
        }
        
        
        // check if user has membership, and change membership button accordingly
        EightMinAbsProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                print("products")
                print(products!)
                print(products![0].productIdentifier)
                var member = EightMinAbsProducts.store.isProductPurchased(products![0].productIdentifier)
                print(member)
                
                // show if member or not
                if member == true {
                    self.memPurchaseBTN.setTitle("See Member Benefits", for: .normal)
                    print("has purchased")
                    UserDefaults.standard.set(true, forKey: "isMember")
                    self.memPurchaseBTN.isUserInteractionEnabled = true

                } else {
                    self.memPurchaseBTN.setTitle("Upgrade and Get More!", for: .normal)
                    print("not a member")
                    UserDefaults.standard.set(false, forKey: "isMember")

                    self.memPurchaseBTN.isUserInteractionEnabled = true

                }
            }
        }


        // end viewdidload
    }
    
    
    
    
    @IBOutlet weak var memPurchaseBTN: UIButton!
    
    
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
