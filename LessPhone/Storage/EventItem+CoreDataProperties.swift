//
//  EventItem+CoreDataProperties.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/28.
//
//

import Foundation
import CoreData


extension EventItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventItem> {
        return NSFetchRequest<EventItem>(entityName: "EventItem")
    }

    @NSManaged public var duration: Int64
    @NSManaged public var isWalking: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: Int16

}

extension EventItem : Identifiable {

}
