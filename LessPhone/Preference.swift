//
//  Preference.swift
//  LessPhone
//  规则、设置
//  Created by 宋申易 on 2022/6/29.
//

import Foundation
protocol AlertRules {
    static func check()
}
struct Preference {
//    let shared = Preference()
    // h: m = beginOfDay / 60 : beginOfDay % 60
    // 一天开始时间，存总分钟数
    static var beginOfDay: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kUserbeginOfDay")
        }
        get {
            UserDefaults.standard.integer(forKey: "kUserbeginOfDay")
        }
    }
    // 屏幕使用时间，存总分钟数
    static var screenLimitTime: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kScreenLimitTime")
        }
        get {
            UserDefaults.standard.integer(forKey: "kScreenLimitTime")
        }
    }
    
    // 超时后，每xx分钟提醒用户，存分钟数
    static var screenLimitTimeRemindPerMinute: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kScreenLimitTimeRemindPerMinute")
        }
        get {
            UserDefaults.standard.integer(forKey: "kScreenLimitTimeRemindPerMinute")
        }
    }
    
    // 是否允许通知
    static var allowNotiUser: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "kAllowNotiUser")
        }
        get {
            UserDefaults.standard.bool(forKey: "kAllowNotiUser")
        }
    }
    
    /// 拿起次数先混在一起
    // 拿起次数挑战
    static var pickupCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kPickupCount")
        }
        get {
            UserDefaults.standard.integer(forKey: "kPickupCount")
        }
    }
    // 拿起次数挑战没拿起几次提示
    static var pickupRemindPerCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kPickupRemindPerCount")
        }
        get {
            UserDefaults.standard.integer(forKey: "kPickupRemindPerCount")
        }
    }
    
    struct Const {
        // 例如23 : 10
        static let beginOfDaytPicker = (hour : (0...6).map { $0 },
                                 minute : (0..<59).map { $0})
        
        // 例如23 : 10
        static let screenLimitPicker = (hour : (0..<24).map { $0 },
                                 minute : (0..<5).map { $0 * 10})
        
        // 小于60分钟 显示1小时
        static let remindPerMinuteArr = [15, 30, 60]
        
        
        // 小于60分钟 显示1小时
        static let pickupCount = [1, 10, 25]
        
        // 小于60分钟 显示1小时
        static let pickupRemindPerCount = [10] + (1...10).map { $0 * 20}
    }
    
    private static var sendScreenTimeTimeStamp: Int = 0
}

extension Preference: AlertRules {
    static func check() {
        // 提醒拿起次数
        if Statistics.shared.pickupCount % Preference.pickupRemindPerCount == 0 {
            LocalNotificationManager.shared.sendPickup(count: Statistics.shared.pickupCount)
        }
        
        // 屏幕时间
        let current = Int(Date().timeIntervalSince1970)
        if sendScreenTimeTimeStamp == 0 ||
            (current - sendScreenTimeTimeStamp >= Preference.screenLimitTimeRemindPerMinute * 60) {
            if (Statistics.shared.screenTime / 60) % Preference.screenLimitTimeRemindPerMinute == 0 {
                LocalNotificationManager.shared.sendScreenTime(second: Statistics.shared.screenTime)
                sendScreenTimeTimeStamp = Int(Date().timeIntervalSince1970)
            }
        }
       
    }
}
