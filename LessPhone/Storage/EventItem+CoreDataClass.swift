//
//  EventItem+CoreDataClass.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/28.
//
//

import Foundation
import CoreData

@objc(EventItem)
public class EventItem: NSManagedObject {
    
    public enum EventType: Int16 {
        // 解锁
        case unlock = 0
        // 锁定
        case lock = 1
        // 开锁情况下timer trigger
        case timerTrigger = 3
    }
    
    public var eventType: EventType {
        EventType(rawValue: type)!
    }
    public override var description: String {
        return "type=\(eventType),isWalking=\(isWalking),duration=\(duration),timestamp=\(timestamp!.beijing())"
    }
}
extension Array {
    func printItems(_ items: [EventItem]) {
        for item in items {
            print(item)
        }
    }
}
