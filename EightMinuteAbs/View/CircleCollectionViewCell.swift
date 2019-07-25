//
//  CircleCollectionViewCell.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 6/10/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("hey there prepare")
        self.layer.borderWidth = 0.0 //whatever the default border width is
        self.layer.borderColor = UIColor.clear.cgColor //whatever the cell's default color is
    }

}
