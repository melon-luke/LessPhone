//
//  LocalNotificationManager.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/13.
//

import Foundation
import SwiftUI
class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    var notifications = [Notification]()
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications permitted")
            } else {
                print("Notifications not permitted")
            }
        }
    }
    
    func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double) {
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false)
        let request = UNNotificationRequest(identifier: "demoNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}

extension LocalNotificationManager {
    func sendAppKill() {
        LocalNotificationManager.shared.sendNotification(title: "请不要关掉我！", subtitle: nil, body: "强制退出后将无法统计到你的屏幕使用时间，点击重新打开", launchIn: 0.1)
    }
    func sendLocation(text: String) {
        LocalNotificationManager.shared.sendNotification(title: "LessPhone当前位置", subtitle: nil, body: text, launchIn: 0.1)
    }
    func sendEvent(text: String) {
//        LocalNotificationManager.shared.sendNotification(title:"LessPhone Event" , subtitle: nil, body: text, launchIn: 0.1)
    }
}
