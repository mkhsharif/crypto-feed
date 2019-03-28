//
//  Pair+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by MKHS on 3/27/19.
//  Copyright © 2019 mkhs. All rights reserved.
//
//

import Foundation
import CoreData


extension Pair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pair> {
        return NSFetchRequest<Pair>(entityName: "Pair")
    }

    @NSManaged public var pair: String?
    @NSManaged public var base: String?
    @NSManaged public var quote: String?
    @NSManaged public var added: Bool

}
