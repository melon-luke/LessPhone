//
//  Statistics.swift
//  LessPhone
//  从数据库查询并统计数据
//  Created by 宋申易 on 2022/6/29.
//

import Foundation
struct Statistics {
    static func hourMinSec(from totalSec: Int) -> (Int, Int, Int) {
        return (totalSec / 3600, totalSec / 60, totalSec % 60)
    }
    static func hourMin(from totalMin: Int) -> (Int, Int) {
        return (totalMin / 60, totalMin % 60)
    }
    
    static func fetchWalkingScreenTime() -> Int {
        var walkingTotalSec = 0
        let items = fetchTodayEventItems()
        if items.count == 0 {
            return 0
        }
        if !items.last!.isWalking {
            return 0
        }
        let reversexItems = items.reversed()
        for item in reversexItems {
            walkingTotalSec += Int(item.duration)
            if !item.isWalking {
                break
            }
        }
        return walkingTotalSec
    }
    
    static func fetchTodayScreenTime() -> Int {
        let totalSec = fetchTodayEventItems()
            .filter { $0.eventType == .timerTrigger }
            .reduce(0) { sum, item in
                sum + item.duration
            }
        return Int(totalSec)
    }
    
    static func fetchTodayUnlockCount() -> Int {
        let items = fetchTodayEventItems().filter { $0.eventType == .unlock }
        return items.count
    }
    
    private static func fetchTodayEventItems() -> [EventItem] {
        if let items = Storage.shared.fetchEventAfterDate(todayBeginDate()) {
            return items
        }
        return []
    }
    
    static func todayBeginDate() -> Date {
        //获取今天凌晨时间
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        let (h,m) = hourMin(from: Preference.beginOfDay)
        components.hour = h
        components.minute = m
        components.second = 0
        return calendar.date(from: components)!
    }
}
