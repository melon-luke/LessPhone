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
    
    private enum EventType: Int16 {
        // 解锁
        case unlock = 0
        // 锁定
        case lock = 1
        // 开锁情况下timer trigger
        case timerTrigger = 3
    }
    
    public override var description: String {
        return "type=\(EventType(rawValue: type)!),isWalking=\(isWalking),duration=\(duration),timestamp=\(timestamp!)"
    }
}
