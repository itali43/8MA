//
//  PurchaseViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/23/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {
    @IBOutlet weak var memberLabel: UILabel!
    var productObject = SKProduct()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Membership"
        // disable purchase button until we are certain they haven't already purchased
        self.purchaseBTN.isUserInteractionEnabled = false
        self.cancelBTN.isHidden = true

        EightMinAbsProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                print("products")
                print(products!)
                print(products![0].productIdentifier)
                self.productObject = products![0]
                var member = EightMinAbsProducts.store.isProductPurchased(products![0].productIdentifier)
                print(member)
                
                // show if member or not
                if member == true {
                    self.memberLabel.text = "You Have a Basic Membership"
                    self.purchaseBTN.isUserInteractionEnabled = false
                    self.purchaseBTN.isHidden = true
                    self.cancelBTN.isHidden = false
                    print("has purchased")

                } else {
                    self.memberLabel.text = "You are NOT currently a Member!!"
                    self.purchaseBTN.isUserInteractionEnabled = true
                    self.purchaseBTN.isHidden = false
                    self.cancelBTN.isHidden = true
                    print("not a member")

                }
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var purchaseBTN: UIButton!
    
    @IBAction func purchaseAction(_ sender: Any) {

        EightMinAbsProducts.store.buyProduct(self.productObject)
//        self.memberLabel.text = ""
        // put a listener for once they've bought. instead of just changing the text no matter what
    }
    
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        var msg =
        """
        You need to go to the Settings App, click on [your name] up top, then on iTunes & App Store.
        Then Tap your Apple ID at the top of the screen, then tap View Apple ID.
        Finally Scroll through Subscriptions and find 8MA's to edit.
        We are sorry to see you go, please leave us some feedback (located in the 8MA's settings menu) for what we can improve!  Thank you!
        """
        Agrippa.popUpAlertSmallText(title: "To Cancel Subscription", message: msg, vc: self)
    }
    
    @IBOutlet weak var cancelBTN: UIButton!
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
