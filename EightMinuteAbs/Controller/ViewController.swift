//
//  ViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/22/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//


/// colors (DEPRECATED!!!!), old black/green
// background: 19191C
// button: 32343B
// text: DFDEE3

import UIKit
import AudioToolbox
import UICircularProgressRing
import RealmSwift

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let testing = false
    var whyDoesItBeepCounter = 0
    @IBOutlet weak var trackerO: UIButton!
    @IBAction func trackerA(_ sender: Any) {
        performSegue(withIdentifier: "toTracker", sender: nil)
    }
    
    
    let realm = try! Realm()
    var passPitcher = "Russian Twist: "
    var abExercise = AbEx(name: "hi", details: "hey", id: 3)
    let greenColor = UIColor(red: 24/256, green: 38/256, blue: 82/256, alpha: 1.0)

    var exercises = [
    "Flutter Kicks",
    "Bicycle Sit Ups",
    "Mountain Climbers",
    "Crunches",
    "Leg Lifters",
    "Supermans",
    "Leg Spreaders",
    "Side Planks",
    "Russian Twist",
    "Sideways Crunches",
    "Russian Twist",
    "Sit Ups",
    "Wipers",
    "Scissors",
    "Toe Taps",
    "Russian Twists",
    "Lying Knee Raises",
    "Figure 8's",
    "Pike Ups (V-Ups)",
    "Side Plank Raises",
    "Reverse Plank",
    "Alt. Sides Superman",
    "Donkey Kicks",
    "Planks",
    ]
    
    
    
    var plankExercises = [
        "Planks",
        "Planks",
        "Planks",
        "Side Planks",
        "Side Plank Raises",
        "Reverse Plank",
    ]

    var roundCounter = 0
    var seconds = 481
    var secondsPast: CGFloat = 0.0
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var itsAReset = false

    @IBOutlet weak var infoBTN: UIButton!
    
    @IBAction func InfoAction(_ sender: Any) {
        print("Popover")
        if abExercise.name == "hi" {
            print("NO!")
        } else {
            performSegue(withIdentifier: "popover", sender: nil)

        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // decide which workout to do
        if Agrippa.defaultexists(forKey: "workout") == true {
            // we have a workout already
            let num = UserDefaults.standard.integer(forKey: "workout")
            changeWorkout(toNum: num)
        } else {
            // no workout yet, must be first time, set to CLASSIC!
            UserDefaults.standard.set(0, forKey: "workout")
            title = "Classic 8MA"
        }
        
    }
    //TO DO--====
    // ADD background mode
    //and/or
    func runTimer() {
        print("run that timer!!!")
        

        var interval = 1
        isTimerRunning = true
        UIApplication.shared.isIdleTimerDisabled = true // doesn't go to sleep
        pauseBTN.isEnabled = true // can press pause
        resetBTN.isEnabled = true // can reset, button is enabled
        skipExerciseBTN.isEnabled = true // can press skip
        if testing == true {
            interval = 1/30
        } else {
            interval = 1
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        

    }

    @objc func updateTimer() {
//        print(seconds)
        if seconds < 1 {
            timer.invalidate()
            roundNumberLabel.text = "1 of 8"
            roundCounter = 0
            
            // temp workout add
            let wkit = Workout()
            wkit.id = Workout.createID()
            wkit.pointsEarned = 1
            wkit.timestamp = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
            
            try! realm.write {
                realm.add(wkit)
                print("written")
            }
            // sound off for the last one!
//            soundAirHorn()
//            buzz()
            // let user access history again
            trackerBTN.isEnabled = true
            pauseBTN.isEnabled = false

//            Agrippa.popUpAlertNoImage(title: "Finished!", message: "Congratulations on successfully completing your workout! It has been logged in your Workout History.", vc: self)


            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            secondsPast = CGFloat(abs(481 - seconds))
            progressRing.value = secondsPast
            timerCountdownLabel.text = timeString(time: TimeInterval(seconds))
        }
        
        if seconds % 60 == 0 {
//            update exercise
            
            if itsAReset == true {
                print ("it's a reset, no sounds")
                itsAReset = false
                
            } else {
                print ("no reset, play sounds")
//                if seconds != 480 {
                    soundAirHorn()
                    buzz()
//                }
                itsAReset = false
            }
            roundCounter += 1
            roundNumberLabel.text = "\(roundCounter) of 8"
            randomExerciseUpdate()
        }
    }

    func randomExerciseUpdate() { // should add a non repeating feature later
        print("update exercise")
        
        // if classic
        let wknum = UserDefaults.standard.integer(forKey: "workout")
        switch wknum {
        case 0:
            print("Classic Workout")
            //        if roundCounter != 8 {
            let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
            exerciseLabel.text = exercises[randomIndex]
            abExercise = AbEx(name: AbEx.getName(id: randomIndex), details: AbEx.getDetails(id: randomIndex), id: randomIndex)
            exerciseLabel.text = abExercise.name
            //        } else {print("ending")}
        case 1:
            print("russian twist Workout")

            // Twist + Shout
            let randomIndex = 8
            exerciseLabel.text = exercises[randomIndex]
            abExercise = AbEx(name: AbEx.getName(id: randomIndex), details: AbEx.getDetails(id: randomIndex), id: randomIndex)
            exerciseLabel.text = abExercise.name

        case 2:
            
            print("planks Workout")

            // Plethora O'Planks
            if roundCounter % 2 == 0 {
                // even round
                let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
                exerciseLabel.text = exercises[randomIndex]
                abExercise = AbEx(name: AbEx.getName(id: randomIndex), details: AbEx.getDetails(id: randomIndex), id: randomIndex)
                exerciseLabel.text = abExercise.name
                print("round of planks: \(roundCounter)")
            } else {
                // send them a plank, it's odd
                let randomIndex = Int(arc4random_uniform(UInt32(plankExercises.count)))
                exerciseLabel.text = plankExercises[randomIndex]
                abExercise = AbEx(name: plankExercises[randomIndex], details: AbEx.getDetailsFrom(name: plankExercises[randomIndex]), id: randomIndex)
                exerciseLabel.text = abExercise.name
                print("round of planks, should be planks: \(roundCounter)")


            }

            
        default:
            //        if roundCounter != 8 {
            let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
            exerciseLabel.text = exercises[randomIndex]
            abExercise = AbEx(name: AbEx.getName(id: randomIndex), details: AbEx.getDetails(id: randomIndex), id: randomIndex)
            exerciseLabel.text = abExercise.name
            //        } else {print("ending")}

        }
        
        
    }
    
    func soundAirHorn() {
        if UserDefaults.standard.bool(forKey: "isAirhorn") == true {
            // play airhorn
            print("sound air horn")
            Sound.play(file: "AirHorn.wav")
        } else {
            // play cheering
            print("sound cheering")
            Sound.play(file: "Cheering.wav")
        }

    }
    
    
    func buzz() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    @IBOutlet weak var pauseBTN: UIButton!
    @IBAction func pauseAction(_ sender: Any) {
        if isTimerRunning == false {
            print ("timer is running is false... must be a new beginning")
            itsAReset = false
            runTimer()
            self.resetBTN.isEnabled = true
            self.pauseBTN.setImage(UIImage(named: "Pause")!, for: .normal)
            self.resumeTapped = false
            trackerBTN.isEnabled = false
            
            if whyDoesItBeepCounter > 0 {
                soundAirHorn()
                buzz()
                randomExerciseUpdate()

            } else {
                whyDoesItBeepCounter += 1
            }
            
            
        } else {

            if self.resumeTapped == false {
                print ("PAUSE ACTION: resume tapped == false, heading to true")
                timer.invalidate()
                self.resumeTapped = true
                self.pauseBTN.setImage(UIImage(named: "Play")!, for: .normal)
                trackerBTN.isEnabled = true

                
                // test leftovers, deleteing your whole dang database
//                try! realm.write {
//                    realm.deleteAll()
//                }

                
                
            } else {
                print ("PLAY ACTION: resume tapped == false, heading to true")
                runTimer()
                self.resumeTapped = false
                self.pauseBTN.setImage(UIImage(named: "Pause")!, for: .normal)
                trackerBTN.isEnabled = false

            }
        }
    } // end pause btn
    
    @IBOutlet weak var skipExerciseBTN: UIButton!
    @IBAction func skipExerciseAction(_ sender: Any) {
        randomExerciseUpdate()
    }
    
    @IBOutlet weak var timerCountdownLabel: UILabel!
    
    @IBOutlet weak var roundNumberLabel: UILabel!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    
    @IBOutlet weak var stopWatchImage: UIImageView!
    
    
//    @IBOutlet weak var startBTN: UIButton!
//    @IBAction func startAction(_ sender: Any) {
//        if isTimerRunning == false {
//            runTimer()
//            self.startBTN.isEnabled = false
//
//
//        }

//    }
    
    
    @IBOutlet weak var settingsBTN: UIBarButtonItem!
    
    @IBAction func settingsAction(_ sender: Any) {
        print("to settings")
        performSegue(withIdentifier: "toSettings", sender: nil)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var resetBTN: UIButton!
    
    @IBAction func resetAction(_ sender: Any) {
        
        itsAReset = true
        rotate(button: resetBTN)
        timer.invalidate()
        seconds = 481
        roundCounter = 0
        secondsPast = CGFloat(abs(481 - seconds))
        print ("reset secondsPast: \(secondsPast)")
        progressRing.value = secondsPast

        roundNumberLabel.text = "\(roundCounter) of 8"
        isTimerRunning = false
        resetBTN.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.resumeTapped = false

        updateTimer()
//        pauseBTN.isEnabled = false
        resumeTapped = true
        self.pauseBTN.setImage(UIImage(named: "Play")!, for: .normal)
        
        skipExerciseBTN.isEnabled = false
        trackerBTN.isEnabled = true
        pauseBTN.isEnabled = true


        



    }
    
    @IBOutlet weak var trackerBTN: UIBarButtonItem!
    @IBAction func trackerAction(_ sender: Any) {
//        if isTimerRunning == false {
            performSegue(withIdentifier: "toTracker", sender: nil)
//        } else {
//            print("no, timer is running")
//        }
        

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func timeString(time:TimeInterval) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let format = "%02i:%02i"
        return String(format: format, minutes, seconds)
    }

    
    func changeWorkout(toNum: Int) {
        if toNum == 0 {
            title = "Classic 8MA"
        }
        if toNum == 1 {
            title = "Twist + Shout"
        }
        if toNum == 2 {
            title = "Plethora O'Planks"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // decide which workout to do
        if Agrippa.defaultexists(forKey: "workout") == true {
            // we have a workout already
            let num = UserDefaults.standard.integer(forKey: "workout")
            changeWorkout(toNum: num)
        } else {
            // no workout yet, must be first time, set to CLASSIC!
            UserDefaults.standard.set(0, forKey: "workout")
            title = "8MA"
        }
        
        // if never been used, add the sound default and set to airhorn. if has, do nothing
        if Agrippa.defaultexists(forKey: "isAirhorn") == false {
            UserDefaults.standard.set(true, forKey: "isAirhorn")
        } else {
            print("isAirhorn Already Exists")
        }

        if let title = skipExerciseBTN.titleLabel?.text{
            skipExerciseBTN.setAttributedTitle(title.getUnderLineAttributedText(), for: .normal)
        }
//        print("hi fonts")
//        for fontFamilyName in UIFont.familyNames {
//            print("family: \(fontFamilyName)\n")
//            
//            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
//                print("font: \(fontName)")
//            }
//        }

        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "InterUI-Bold", size: 18)!]

        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarStyle = .default

        // Make Progress ring
        progressRing.maxValue = 481
        progressRing.minValue = 0
        progressRing.gradientColors = [.white, greenColor]
        progressRing.gradientColorLocations = [0.5, 1.0]
        progressRing.gradientStartPosition = .left
        progressRing.gradientEndPosition = .bottomRight
        progressRing.ringStyle = .gradient
        progressRing.innerCapStyle = .butt
        progressRing.innerRingColor = .white
        pauseBTN.isEnabled = true
        skipExerciseBTN.isEnabled = false
        resetBTN.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false

        // Reset All Buttons/Navigation
        self.pauseBTN.setImage(UIImage(named: "Play")!, for: .normal)

        pauseBTN.layer.cornerRadius = 0.5 * pauseBTN.bounds.size.width
        pauseBTN.clipsToBounds = true
        
        
        resetBTN.layer.cornerRadius = 0.5 * resetBTN.bounds.size.width
        resetBTN.clipsToBounds = true

        trackerBTN.isEnabled = true

        pauseBTN.isEnabled = true



        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popover" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            let vc = segue.destination as? InfoPopUpViewController
            vc?.passReceive = abExercise.details
        }

    }

    
    func rotate(button: UIButton) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            button.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi * 0.999))
        }
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: { () -> Void in
            button.transform = CGAffineTransform(rotationAngle: (CGFloat.pi * 1.999))
        }, completion: nil)
    }
    


}

