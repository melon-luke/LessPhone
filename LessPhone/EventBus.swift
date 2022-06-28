//
//  EventBus.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/4.
//

import UIKit
import Combine
import CoreMotion

class EventBus {
    static let shared = EventBus()
    
    /// 锁屏解锁事件
    private let lockNotifi = NotificationCenter.default
        .publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
    private var lockCancellable: AnyCancellable?
    
    private let unlockNotifi = NotificationCenter.default
        .publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
    private var unlockCancellable: AnyCancellable?
    
    private var isUnLocking = false
    private let duration: TimeInterval = 10
    private var timer: Timer.TimerPublisher
    private var timerCancellable: AnyCancellable?
    
    /// 检测当前是否在走路
    private let motionActivityManager = CMMotionActivityManager()
    private var isWalking = false
    
    private let pedometer = CMPedometer()
    private var previosDate = Date()
    private var midnightOfToday: Date = {
        //获取今天凌晨时间
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return cal.date(from: comps)!
    }()
    init() {
        timer = Timer.publish(every: duration, on: .main, in: .default)
        listenLockEvent()
        unLockAction()
    }
    
    private func listenLockEvent() {
        unlockCancellable = unlockNotifi.sink { [weak self] noti in
            guard let self = self else { return }
            rp("unlock")
            self.unLockAction()
        }
        
        lockCancellable = lockNotifi.sink { [weak self] notif in
            guard let self = self else { return }
            self.isUnLocking = false
            //            self.endRecordModtion()
            rp("lock")
            self.timerCancellable?.cancel()
            Storage.shared.addLockEvent(isLocked: true)
        }
    }
    private func unLockAction() {
        self.isUnLocking = true
//        self.startRecordMotion()
        Storage.shared.addLockEvent(isLocked: false)
        self.timerCancellable = self.timer
            .autoconnect()
            .sink(receiveValue: { timer in
                if self.isUnLocking {
                    self.fetchStepCount { isWalking in
                        Storage.shared.addTimerTriggerEvent(duration: Int64(self.duration), isWalking: isWalking)
                    }
                }
            })
    }
    private func triggerAlert() {
        // TODO: 调用Alert
    }
    private func fetchStepCount(_ completion: @escaping (Bool) -> ()) {
        //初始化并开始实时获取数据
        self.pedometer.queryPedometerData(from: previosDate, to: Date()) { pedometerData, error in
            //获取各个数据
            var text = "numberOfSteps="
            if let numberOfSteps = pedometerData?.numberOfSteps {
                text += "\(numberOfSteps)"
                self.isWalking = numberOfSteps.intValue > 4
            }
            rp(text)
            completion(self.isWalking)
        }
    }
//    private func startRecordMotion() {
//        //判断设备支持情况
//        guard CMPedometer.isStepCountingAvailable() else {
//            return
//        }
//
//        //获取今天凌晨时间
//        let cal = Calendar.current
//        var comps = cal.dateComponents([.year, .month, .day], from: Date())
//        comps.hour = 0
//        comps.minute = 0
//        comps.second = 0
//        let midnightOfToday = cal.date(from: comps)!
//
//
//        self.pedometer.startUpdates (from: midnightOfToday, withHandler: { pedometerData, error in
//            //错误处理
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            //获取各个数据
//            var text = "---今日运动数据---\n"
//            if let numberOfSteps = pedometerData?.numberOfSteps {
//                text += "步数: \(numberOfSteps)\n"
//            }
//            if let distance = pedometerData?.distance {
//                text += "距离: \(distance)\n"
//            }
//            if let floorsAscended = pedometerData?.floorsAscended {
//                text += "上楼: \(floorsAscended)\n"
//            }
//            if let floorsDescended = pedometerData?.floorsDescended {
//                text += "下楼: \(floorsDescended)\n"
//            }
//            if let currentPace = pedometerData?.currentPace {
//                text += "速度: \(currentPace)m/s\n"
//            }
//            if let currentCadence = pedometerData?.currentCadence {
//                text += "速度: \(currentCadence)步/秒\n"
//            }
//
//            //在线程中更新文本框数据
//            DispatchQueue.main.async{
//                self.textView.text = text
//            }
//        })
//
//        motionActivityManager.startActivityUpdates(to: .main) { [weak self] activity in
//            guard let self = self,
//                  let activity = activity else { return }
//            self.isWalking = activity.walking || activity.running
//            //            rp("\(activity.walking  ? "isWalking" : "")")
//            //            rp("\(activity.running  ? "running" : "")")
//            //            rp("\(activity.automotive  ? "automotive" : "")")
//            //            rp("\(activity.cycling  ? "cycling" : "")")
//            //            rp("\(activity.stationary  ? "stationary" : "")")
//
//        }
//    }
//    private func endRecordModtion() {
//        motionActivityManager.stopActivityUpdates()
//    }
}
