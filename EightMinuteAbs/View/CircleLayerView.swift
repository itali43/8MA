//
//  CircleLayerView.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 2/6/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit
class CircleLayerView: UIView {
    public var dotNumber = 2
    var circleLayer: CAShapeLayer!
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var circles: Array<CAShapeLayer> = []
        print("turns out the dot is: \(dotNumber)")
        for i in 1...dotNumber {
            print("python has me thinking wrong \(i)")
            var newCircle = CAShapeLayer()
            let radius: CGFloat = 15.0
            newCircle.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
            var moreX = self.frame.minX + 30.0
            var moreY = CGFloat(i)*35.0
            var newYline: CGFloat = 1.0
            var newXline = 1.0
            newCircle.fillColor = UIColor(hexStr: "F5FCFE").cgColor
            var evenMoreX = 0.0
           
            if i > 30 {
                newYline = CGFloat(2.0) * (CGFloat(-4.0)*35.0 - CGFloat(150.0))
                evenMoreX = -120.0
            } else if i > 10 && i < 20 {
                newYline = CGFloat(-4.0)*35.0 - CGFloat(150.0)
//                newCircle.fillColor = UIColor(hexStr: "F4F4F4").cgColor
                evenMoreX = -60.0
            } else {
                newYline = 0.0
            }
            newCircle.position = CGPoint(x: self.frame.midX - radius - moreX - CGFloat(evenMoreX), y: self.frame.midY + CGFloat(150.0) - radius - moreY - newYline)
            circles.append(newCircle)
            self.layer.addSublayer(newCircle)
        }

        print(circles.count)
        
//        if circleLayer == nil {
//            circleLayer = CAShapeLayer()
//            let radius: CGFloat = 15.0
//            circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
//            circleLayer.position = CGPoint(x: self.frame.midX - radius, y: self.frame.midY - radius)
//            circleLayer.fillColor = UIColor(hexStr: "66FF66").cgColor
//            self.layer.addSublayer(circleLayer)
//            let myTextLayer = CATextLayer()
//            myTextLayer.string = "1"
//            myTextLayer.foregroundColor = UIColor.black.cgColor
//            myTextLayer.frame = CGRect(x:  self.frame.midX - radius, y:  self.frame.midY - radius, width: 3.0 * radius, height: 3.0 * radius)
//            myTextLayer.position = CGPoint(x: self.frame.midX - radius, y: self.frame.midY - radius)
//            self.layer.addSublayer(myTextLayer)
//        }
    }
}



//        let workouts: Array<Date> = [Date(timeIntervalSince1970: 1549493094), Date(timeIntervalSince1970: 1549152000), Date(timeIntervalSince1970: 1548460800) ]







