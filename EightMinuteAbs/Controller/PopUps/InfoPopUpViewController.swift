//InfoPopUpViewController
//  InfoPopUpViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 9/30/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import UIKit

class InfoPopUpViewController: UIViewController {
    
    @IBOutlet weak var infoView: UITextView!
    
    var passReceive =  "Russian Twist: \n Assume crunch position with feet and head held above floor.  Move exercise ball or interlocked hands back and forth above abs alternating sides hitting the floor."
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoView.centerVertically()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.clipsToBounds = true
        infoView.layer.cornerRadius = 10
        infoView.text = passReceive

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
