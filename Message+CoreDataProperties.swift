//
//  Message+CoreDataProperties.swift
//  Messenger
//
//  Created by Egor on 14.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var friend: Friend?

}
