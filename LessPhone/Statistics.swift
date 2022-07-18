//
//  Statistics.swift
//  LessPhone
//  从数据库查询并统计数据, model
//  Created by 宋申易 on 2022/6/29.
//

import Foundation

class Statistics: ObservableObject {
    // 屏幕时间(秒)
    @Published var screenTime: Int = 0 {
        didSet {
            screenTimeInStill = screenTime - screenTimeInWalking
        }
    }
    // 屏幕时间(秒)
    @Published var screenTimeInWalking: Int = 0
    // 呆呆地看(秒)
    @Published var screenTimeInStill: Int = 0
    // 今天拿起次数
    @Published var pickupCount: Int = 0
    // （今天）第一次拿起
    @Published var firstTimePickup: Date?
    // 昨天最后一次放下
    @Published var lastTimePutDownYesterday: Date?
    // 今天最后一次放下
    @Published var lastTimePutDownToday: Date?

    
    static let shared = Statistics()
    init () {
        
    }
    func updateRealTimeInSecond(isWalking: Bool) {
        screenTime = screenTime + 1
        if (isWalking) {
            screenTimeInWalking += 1
        }
    }
    func calculateAllData() {
        screenTimeInWalking = 0
        let items = fetchTodayEventItems()
        calculateTodayPickUpDownTime(items: items)
        pickupCount = calculateUnlockCount(items: items)
        screenTime = max(screenTime, calculateScreenTime(items: items))
        screenTimeInWalking = max(screenTimeInWalking, calculateWalkingScreenTime(items: items))
        Preference.check()
    }
    func calculateWalkingScreenTime(items: [EventItem]) -> Int {
        var walkingTotalSec = 0
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
    
    func calculateTodayPickUpDownTime(items: [EventItem]) {
        var curIdx = 0
        for i in 0..<items.count {
            curIdx = i
            if items[i].eventType == .unlock {
                firstTimePickup = items[i].timestamp
                break
            }
        }
        if curIdx > 0 {
            let lastItem = items[curIdx - 1]
            if lastItem.eventType == .lock {
                lastTimePutDownYesterday = items[curIdx - 1].timestamp
            }
        } else {
            let lastItemYesterday = fetchYesterdayLastLockItem()
            if lastItemYesterday?.eventType == .lock {
                lastTimePutDownYesterday = lastItemYesterday?.timestamp
            }
        }
    }

    
    func calculateScreenTime(items: [EventItem]) -> Int {
        var lockUnlockTotalSec = 0
        var unlockTimeStamp = 0
        for item in items {
            if item.eventType == .unlock {
                unlockTimeStamp = Int(item.timestamp?.timeIntervalSince1970 ?? 0.0)
            }
            if item.eventType == .lock {
                let lockTimeStamp = Int(item.timestamp?.timeIntervalSince1970 ?? 0.0)
                lockUnlockTotalSec += lockTimeStamp - unlockTimeStamp
            }
        }
//        return totalSec
        let durationTotalSec = items
            .filter { $0.eventType == .timerTrigger }
            .reduce(0) { sum, item in
                sum + item.duration
            }
        return max(lockUnlockTotalSec, Int(durationTotalSec))
    }
    
    func calculateUnlockCount(items: [EventItem]) -> Int {
        let items = items.filter { $0.eventType == .unlock }
        return items.count
    }
    
    private func fetchTodayEventItems() -> [EventItem] {
        if let items = Storage.shared.fetchEventAfterDate(todayBeginDate()) {
            print("今天之后的数据")
            print(items)
            return items
        }
        return []
    }
    private func fetchYesterdayLastLockItem() -> EventItem? {
        if let items = Storage.shared.fetchEventBeforeDate(todayBeginDate(), type: .lock, count: 1) {
            print("今天之前的数据")
            print(items)
            return items.last
        }
        return nil
    }
    
    func todayBeginDate() -> Date {
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
//
extension Date {
    // 返回北京时间
    static func current() -> Date {
        let date = Date()
        let interval = NSTimeZone.system.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }
    // 返回北京时间
    func beijing() -> Date {
        let interval = NSTimeZone.system.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(interval))
    }
    private static let formatter =  DateFormatter()
    func beijingStr(_ formatterStr: String) -> String {
//        let interval = NSTimeZone.system.secondsFromGMT(for: self)
//        let date = self.addingTimeInterval(TimeInterval(interval))
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = formatterStr
////        [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)//NSTimeZone(name: <#T##String#>)
//        return dateFormatter.string(from: self)

        Date.formatter.dateFormat = formatterStr
        
//        formater.locale = Locale(identifier: "zh_hans_CN")
        Date.formatter.timeZone = TimeZone.current
//        formater.dateStyle = .medium
//        formater.timeStyle = .medium
        return Date.formatter.string(from: self)
    }
}
extension Statistics {
    func hourMinSec(from totalSec: Int) -> (Int, Int, Int) {
        return (totalSec / 3600, totalSec / 60, totalSec % 60)
    }
    func hourMin(from totalMin: Int) -> (Int, Int) {
        return (totalMin / 60, totalMin % 60)
    }
}
