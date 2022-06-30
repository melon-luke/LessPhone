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
    static func fetchTodayScreenTime() -> Int {
        var totalSec = 0
        if let items = Storage.shared.fetchEventAfterDate(todayBeginDate(), type: .timerTrigger) {
//            totalSec = items.count * Int(items.first?.duration ?? 0)
            totalSec = Int(items.reduce(0) { sum, item in
                sum + item.duration
            })
        }
        return totalSec
    }
    
    static func fetchTodayUnlockCount() -> Int {
        var totalCount = 0
        if let items = Storage.shared.fetchEventAfterDate(todayBeginDate(), type: .unlock) {
            totalCount = items.count
        }
        return totalCount
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
