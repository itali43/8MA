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
                } else {
                    self.memberLabel.text = "You are NOT currently a Member!!"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var purchaseBTN: UIButton!
    
    @IBAction func purchaseAction(_ sender: Any) {
        
        EightMinAbsProducts.store.buyProduct(self.productObject)
        
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
