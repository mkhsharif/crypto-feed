//
//  Price+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by MKHS on 3/27/19.
//  Copyright © 2019 mkhs. All rights reserved.
//
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var ticker: String?
    @NSManaged public var price: String?
    @NSManaged public var percentChange: String?

}
