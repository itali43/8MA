//
//  Wallet.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 2/15/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//

import Foundation
import RealmSwift

class Specimen: Object {
    @objc dynamic var name = ""
    @objc dynamic var specimenDescription = ""
    @objc dynamic var latitude = 0.0
   @objc dynamic var longitude = 0.0
   @objc dynamic var created = NSDate()

    
}
