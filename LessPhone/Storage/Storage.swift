//
//  Storage.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/5.
//

import Foundation
import CoreData
import SwiftUI

struct Storage {
    

    static let shared = Storage()
    fileprivate var viewContext: NSManagedObjectContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \EventItem.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<EventItem>
    
    init() {
        let coreDataManager = CoreDataManager()
        viewContext = coreDataManager.container.viewContext
    }

    // 插入
    func addLockEvent(isLocked: Bool) {
       saveLockEvent(isLocked: isLocked)
    }
    // 插入
    func addTimerTriggerEvent(duration: Int64, isWalking: Bool) {
        saveTimerTriggerEvent(duration: duration, isWalking: isWalking)
    }
    
    // 查询
    func fetch() {
        let request = EventItem.fetchRequest()
//        request.predicate = NSPredicate(format: "timestamp <= %d", NSDate().timeIntervalSince1970)
        request.predicate = NSPredicate(value: true)
        let items = try? viewContext.fetch(request)
        //修改
        if let items = try? viewContext.fetch(request) {
            for item in items {
                print(item)
            }
        }
//        //修改
//        if let items = try? viewContext.fetch(request) {
//            for item in items {
//                item.isWalking = false
//            }
//        }
//        saveToContext()
    }
//
//    // 删除
//    func delete() {
//        let request = EventItem.fetchRequest()
//        request.predicate = NSPredicate(format: "timestamp <= %d", NSDate().timeIntervalSince1970)
//
//        if let items = try? viewContext.fetch(request) {
//            for item in items {
//                viewContext.delete(item)
//            }
//        }
//        saveToContext()
//    }
    
    private enum EventType: Int16 {
        // 解锁
        case unlock = 0
        // 锁定
        case lock = 1
        // 开锁情况下timer trigger
        case timerTrigger = 3
    }
    
    private func saveLockEvent(isLocked: Bool) {
        viewContext.perform {
            let event = EventItem(context: viewContext)
            event.type = isLocked ? EventType.lock.rawValue : EventType.unlock.rawValue
            event.timestamp = Date()
            saveToContext()
        }
    }
    
    private func saveTimerTriggerEvent(duration: Int64, isWalking: Bool) {
        viewContext.perform {
            let event = EventItem(context: viewContext)
            event.type = Storage.EventType.timerTrigger.rawValue
            event.timestamp = Date()
            event.duration = duration
            event.isWalking = isWalking
            saveToContext()
        }
    }
    
    private func saveToContext() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
