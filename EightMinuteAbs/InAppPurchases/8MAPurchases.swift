//
//  8MAPurchases.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/23/19.
//  Copyright © 2019 AgrippaApps. All rights reserved.
//


import Foundation

public struct EightMinAbsProducts {
    
    public static let SwiftShopping = "com.AgrippaApps.EightMinuteAbs.membership"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [EightMinAbsProducts.SwiftShopping]
    
    public static let store = IAPHelper(productIds: EightMinAbsProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
