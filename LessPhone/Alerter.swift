//
//  Alerter.swift
//  LessPhone
//  提醒规则检查器
//  Created by 宋申易 on 2022/7/22.
//

import Foundation

class Alerter {
    private static var sendScreenTimeTimeStamp: Int = 0
    private static var pickupCount: Int = 0

    static func runRules() {
        // 提醒拿起次数
        if Statistics.shared.pickupCount > pickupCount {
            if Statistics.shared.pickupCount % Preference.pickupRemindPerCount == 0 {
                LocalNotificationManager.shared.sendPickup(count: Statistics.shared.pickupCount)
                pickupCount = Statistics.shared.pickupCount
            }
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
