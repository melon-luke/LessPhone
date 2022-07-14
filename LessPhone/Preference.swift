//
//  Preference.swift
//  LessPhone
//  规则、设置
//  Created by 宋申易 on 2022/6/29.
//

import Foundation
protocol AlertRules {
    func check()
}
struct Preference {
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
    static var remindPerMinute: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kRemindPerMinute")
        }
        get {
            UserDefaults.standard.integer(forKey: "kRemindPerMinute")
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
    struct Const {
        // 例如23 : 10
        let beginOfDaytPicker = (hour : (0...6).map { $0 },
                                 minute : (0..<59).map { $0})
        
        // 例如23 : 10
        let screenLimitPicker = (hour : (0..<24).map { $0 },
                                 minute : (0..<5).map { $0 * 10})
        
        // 小于60分钟 显示1小时
        let remindPerMinuteArr = [15, 30, 60]
    }
}

extension Preference: AlertRules {
    func check() {
        
    }
}
