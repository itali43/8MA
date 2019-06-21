//
//  TrackingHomeViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 11/7/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit
//import Charts
import Foundation
import RealmSwift

class AbExercise: Object {
    @objc dynamic var  name = ""
    @objc dynamic var  details = ""
    @objc dynamic var  id = ""
}
class Wallet: Object {
    @objc dynamic var balance = 0
}
class Workout: Object {
    @objc dynamic var id = "1233456789"
    @objc dynamic var timestamp: Date? = Date() // optionals supported
    let exercises = List<AbExercise>()
    @objc dynamic var pointsEarned = 0
    
    static func createID() -> String {
        let uuid = NSUUID().uuidString
        print("Workout ID: \(uuid)")
        return uuid
    }
}


class TrackingHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate  {
    
    @IBOutlet weak var workoutGrid: UICollectionView!

    var daysFromWorkOutArr = [Double]()
    var totalWorkouts = 0
    
    var datesWorkedOut = [Date]()

    let realm = try! Realm()

    var items = ["1", "2"]
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    
    
    
    func computeNewDate(from fromDate: Date, to toDate: Date) -> Date  {
        let delta = toDate.timeIntervalSince(fromDate)
        let today = Date()
        if delta < 0 {
            return today
        } else {
            return today.addingTimeInterval(delta)
        }
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print( "touched: \(indexPath.row)")
        // setting cell's date, and outlining it
        let date = Date(timeIntervalSinceNow: TimeInterval(indexPath.row * -86400))
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor(red: 6/100, green: 20/100, blue: 65/100, alpha: 1.0).cgColor
        cell?.layer.borderWidth = 4

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        
        
        
        // decide if multiple workouts have been done, change color if so.
        var workoutDayCount = 0
        for workoutDate in datesWorkedOut {
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MM/dd"
            dateFormatter2.timeZone = .current
            let wkoutDate = dateFormatter2.string(from: workoutDate)
            if wkoutDate == localDate {
                // user worked out on this date
                //                print("there was workout")
                workoutDayCount += 1
            }
            //            else {
            //                // user did NOT work out on this date
            //                print("NO! for background")
            //
            //            }
        }
        print("workoutDayCount: \(workoutDayCount)")
        

        
        
        
        
        
        
        
        // decide if worked out or not, if so tells user and return, if not runs thru all
        for workoutDate in datesWorkedOut {
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MM/dd"
            dateFormatter2.timeZone = .current
            let wkoutDate = dateFormatter2.string(from: workoutDate)
            if wkoutDate == localDate {
                // user worked out on this date
                if workoutDayCount == 1 {
                    dateLabel.text = localDate + "- Worked Out Once"
                } else if workoutDayCount == 2{
                    dateLabel.text = localDate + "- Worked Out Twice"
                } else {
                    dateLabel.text = localDate + "- Worked Out x\(workoutDayCount)"
                }
                print("there was workout")
                return
            } else {
                // user did NOT work out on this date
                dateLabel.text = localDate + "- Rest Day"
                print("rest day.. \(localDate)")
                

            }
        }

    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CircleCollectionViewCell

//        cell.layer.borderColor = UIColor(red: 6/100, green: 20/100, blue: 65/100, alpha: 1.0).cgColor
//        cell.layer.borderWidth = 1
        
        let hadWorkout = daysFromWorkOutArr.contains { $0 == Double(indexPath.row)}
//        print ("hadWorkout: \(hadWorkout),   indexPath \(indexPath.row)")
        if hadWorkout == false {
            cell.backgroundColor = UIColor.lightGray //UIColor(red: 96/100, green: 99/100, blue: 100/100, alpha: 1.0)
        } else {
            print("had some!: \(indexPath.row)")
            cell.backgroundColor = UIColor(red: 67/100, green: 78/100, blue: 92/100, alpha: 1.0)
        }
        
        
        // find day of this cell
        let date = Date(timeIntervalSinceNow: TimeInterval(indexPath.row * -86400))
        // format properly
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        print (localDate)
        
        // decide if it should be labeled with the date (end of the month days)
        // 31 day months
        if localDate.hasPrefix("01") ||  localDate.hasPrefix("03") ||  localDate.hasPrefix("05") ||  localDate.hasPrefix("07") ||  localDate.hasPrefix("08") ||  localDate.hasPrefix("10") ||  localDate.hasPrefix("12") ||  localDate.hasPrefix("01") {
            if localDate.hasSuffix("31") {
                dateFormatter.dateFormat = "LLL"
                let nameOfMonth = dateFormatter.string(from: date)
                let month = "\(nameOfMonth.uppercased())"
                cell.label.text = month
            } else {
                // if not end of the month, do not label
                cell.label.text = ""
            }
        }
        
        // 30 day months
        if localDate.hasPrefix("04") ||  localDate.hasPrefix("06") ||  localDate.hasPrefix("09") ||  localDate.hasPrefix("11") {
            if localDate.hasSuffix("30") {
                dateFormatter.dateFormat = "LLL"
                let nameOfMonth = dateFormatter.string(from: date)
                let month = "\(nameOfMonth.uppercased())"
                cell.label.text = month
                
                
            } else {
                cell.label.text = ""
            }
        }
    // The Red-Headed StepChild that is February
        if localDate.hasPrefix("02")  {
            if localDate.hasSuffix("28") {
                dateFormatter.dateFormat = "LLL"
                let nameOfMonth = dateFormatter.string(from: date)
                let month = "\(nameOfMonth.uppercased())"
                cell.label.text = month
            } else {
                cell.label.text = ""
            }
        }
        
        // decide if multiple workouts have been done, change color if so.
        var workoutDayCount = 0
        for workoutDate in datesWorkedOut {
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MM/dd"
            dateFormatter2.timeZone = .current
            let wkoutDate = dateFormatter2.string(from: workoutDate)
            if wkoutDate == localDate {
                // user worked out on this date
//                print("there was workout")
                workoutDayCount += 1
            }
//            else {
//                // user did NOT work out on this date
//                print("NO! for background")
//
//            }
        }
        print("workoutDayCount: \(workoutDayCount)")
        if workoutDayCount == 2 {
            cell.backgroundColor = UIColor(hexStr: "4c8ad4")
        }
        if workoutDayCount == 3 {
            cell.backgroundColor = UIColor(hexStr: "0000FF")
        }
        if workoutDayCount == 4 {
            cell.backgroundColor = UIColor(hexStr: "1034A6")
        }
        if workoutDayCount >= 5 {
            cell.backgroundColor = UIColor(hexStr: "091e5e")
        }



        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //        cell.myLabel.text = self.items[indexPath.item]
        
        return cell
        
    }
    

    @IBAction func homeBarButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)

    }
    
    
    @IBOutlet weak var homeO: UIButton!
    @IBAction func homeA(_ sender: Any) {
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(navigationController?.navigationBar.isHidden)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        print(navigationController?.navigationBar.isHidden)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dateLabel.text = "~"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = ""
        dateLabel.text = "~"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 21)!]

        DispatchQueue.main.async {
            /*
             spits out this format:
             
             Results<Workout> <0x7f95f25a1560> (
             [0] Workout {
             id = A7BD0E99-B5C4-4D2D-A448-702A3FEF3599;
             timestamp = 2019-06-21 00:13:44 +0000;
             exercises = List<AbExercise> <0x600002bb2a30> ( );
             pointsEarned = 1;
             },
             [1] Workout {
             id = 6543C27D-988E-43EB-85D3-D2A54310D955;
             timestamp = 2019-06-21 00:13:57 +0000;
             exercises = List<AbExercise> <0x600002bb4900> ( );
             pointsEarned = 1;
             }
             )
             
             */
            let puppies = self.realm.objects(Workout.self)

            print("these were the puppies")
            for i in puppies {
                print(i.timestamp!)
                self.datesWorkedOut.append(i.timestamp!)
             }
            self.totalWorkouts = self.datesWorkedOut.count
            
            // Dates to Days: build out more
            let now = Date()
            let timeZone = NSTimeZone.system
            let timeZoneOffset = timeZone.secondsFromGMT(for: now) / 3600
            print ("timezone: \(timeZoneOffset)")
//            print(now.compare(timeZoneOffset))
            if timeZoneOffset < 0 {
                // timezone is negative, subtract
                
            } else {
                // timezone is positive, add
            }
            
            
            print(Date().description(with: .current))
            print("wtf date?")
            print ("now: \(now)")
            for date in self.datesWorkedOut{
                
                print("then: \(date)")
                var diff = now - date
                var diffdays = (diff / 86400).rounded(.down)
                print("difference: \(diffdays)")
                self.daysFromWorkOutArr.append(diffdays)
                
            }
            self.workoutGrid.reloadData()
            self.titleLabel.text = "\(self.totalWorkouts) Ab Workouts"
            self.dateLabel.text = "~"


        }

         
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    


//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
}
