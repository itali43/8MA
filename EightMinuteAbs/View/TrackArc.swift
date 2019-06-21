//
//  TrackArc.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 2/13/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit

@IBDesignable class TrackArc: UIView {
        private struct Constants {
            static let numberOfGlasses = 30
            static let lineWidth: CGFloat = 5.0
            static let arcWidth: CGFloat = 76
            
            static var halfOfLineWidth: CGFloat {
                return lineWidth / 2
            }
        }
        public var dotNumber = 2
        public var counter = 5
        @IBInspectable var outlineColor: UIColor = UIColor.blue
        @IBInspectable var counterColor: UIColor = UIColor.orange
    
    /*1. Define the center point of the view where you’ll rotate the arc around.
    2. Calculate the radius based on the max dimension of the view.
    3. Define the start and end angles for the arc.
    4. Create a path based on the center point, radius, and angles you just defined.
    5. Set the line width and color before finally stroking the path. */

        override func draw(_ rect: CGRect) {
            
            // 1
            let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            // 2
            let radius: CGFloat = max(bounds.width, bounds.height)
            // 3
            let startAngle: CGFloat = 3 * .pi / 4
            let endAngle: CGFloat = .pi / 4
            // 4
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius/2 - Constants.arcWidth/2,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            // 5
            path.lineWidth = Constants.arcWidth
            counterColor.setStroke()
            path.stroke()
            
            // outline
            //****Draw the outline****
            //1 - first calculate the difference between the two angles
            //ensuring it is positive
            let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
            //then calculate the arc for each single glass
            let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
            //then multiply out by the actual glasses drunk
            let outlineEndAngle = arcLengthPerGlass * CGFloat(dotNumber) + startAngle
            
            //2 - draw the outer arc
            let outlinePath = UIBezierPath(arcCenter: center,
                                           radius: bounds.width/2 - Constants.halfOfLineWidth,
                                           startAngle: startAngle,
                                           endAngle: outlineEndAngle,
                                           clockwise: true)
            
            //3 - draw the inner arc
            outlinePath.addArc(withCenter: center,
                               radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                               startAngle: outlineEndAngle,
                               endAngle: startAngle,
                               clockwise: false)
            
            //4 - close the path
            outlinePath.close()
            
            outlineColor.setStroke()
            outlinePath.lineWidth = Constants.lineWidth
            outlinePath.stroke()
            
            
            
            
            
            
            //Counter View markers --------------------
            let context = UIGraphicsGetCurrentContext()!
            
            //1 - save original state
            context.saveGState()
            outlineColor.setFill()
            
            let markerWidth: CGFloat = 5.0
            let markerSize: CGFloat = 10.0
            
            //2 - the marker rectangle positioned at the top left
            let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
            
            //3 - move top left of context to the previous center position
            context.translateBy(x: rect.width / 2, y: rect.height / 2)
            
            for i in 1...Constants.numberOfGlasses {
                //4 - save the centred context
                context.saveGState()
                //5 - calculate the rotation angle
                let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
                //rotate and translate
                context.rotate(by: angle)
                context.translateBy(x: 0, y: rect.height / 2 - markerSize)
                
                //6 - fill the marker rectangle
                markerPath.fill()
                //7 - restore the centred context for the next rotate
                context.restoreGState()
            }
            
            //8 - restore the original state in case of more painting
            context.restoreGState()

        }
    
    
    
}
