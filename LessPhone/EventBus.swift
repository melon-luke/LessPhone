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
    /// 锁屏解锁事件 （必须声明成全局变量，否则离开作用域就回收了）
    private let lockNotifi = NotificationCenter.default
        .publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)
    private var lockCancellable: AnyCancellable?
    
    private let unlockNotifi = NotificationCenter.default
        .publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)
    private var unlockCancellable: AnyCancellable?

    
    var isUnLocking = false
    private let duration: TimeInterval = 10
    
    // 定时存数据库 timer
    private var timer: Timer.TimerPublisher
    private var timerCancellable: AnyCancellable?
    
    // 实时更新数据UI timer
    private var realTimeUITimer: Timer.TimerPublisher
    private var realTimeUITimerCancellable: AnyCancellable?
     
    /// 检测当前是否在走路 (计步器)
    private var isWalking = false
    private let pedometer = CMPedometer()
    private var previosDate = Statistics.shared.todayBeginDate()
    private var numberOfSteps = 0

    init() {
        timer = Timer.publish(every: duration, on: .main, in: .default)
        realTimeUITimer = Timer.publish(every: 1, on: .main, in: .default)
        fetchStepCount(notifUser: false)
        listenLockEvent()
        unLockAction()
    }
    func appActive(_ active: Bool) {
        if active {
            self.realTimeUITimerCancellable = self.realTimeUITimer
                .autoconnect()
                .sink(receiveValue: { [weak self] timer in
                    guard let self = self else { return }
                    Statistics.shared.updateRealTimeInSecond(isWalking: self.isWalking)
                })
            fetchStepCount(notifUser: false)
            triggerAlert()
        } else {
            self.realTimeUITimerCancellable?.cancel()
        }
        
    }
    private func listenLockEvent() {
        /// 锁屏解锁事件
        unlockCancellable = unlockNotifi.sink { [weak self] noti in
            guard let self = self else { return }
            rp("unlock")
            self.unLockAction()
        }
        
        /// 锁屏事件
        lockCancellable = lockNotifi.sink { [weak self] notif in
            guard let self = self else { return }
            self.isUnLocking = false
            rp("lock")
            self.timerCancellable?.cancel()
            self.realTimeUITimerCancellable?.cancel()
            Storage.shared.addLockEvent(isLocked: true)
            LocalNotificationManager.shared.sendEvent(text: "lockScreen")
        }
    }
    private func unLockAction() {
        self.isUnLocking = true
        Storage.shared.addLockEvent(isLocked: false)
        LocalNotificationManager.shared.sendEvent(text: "unLockScreen")
        self.timerCancellable = self.timer
            .autoconnect()
            .sink(receiveValue: { [weak self] timer in
                guard let self = self,
                      self.isUnLocking else {
                    return
                }
                self.fetchStepCount { isWalking in
                    Storage.shared.addTimerTriggerEvent(duration: Int64(self.duration), isWalking: isWalking)
                }
                LocalNotificationManager.shared.sendEvent(text: "timer, iswalking=\(self.isWalking)")
//                self.triggerAlert()
            })
    }
    private func triggerAlert() {
        Statistics.shared.calculateAllData()
    }
    private func fetchStepCount(notifUser: Bool? = true, _ completion: ((Bool) -> ())? = nil) {
        //初始化并开始实时获取数据
        let current = Date()
        self.pedometer.queryPedometerData(from: previosDate, to: current) { pedometerData, error in
            //获取各个数据
            var text = "queryPedometer "
            if let numberOfSteps = pedometerData?.numberOfSteps {
                text += "Steps=\(numberOfSteps.intValue)"
                self.previosDate = current
                self.isWalking = numberOfSteps.intValue > 0
                self.numberOfSteps = self.numberOfSteps + numberOfSteps.intValue
//                //在线程中更新文本框数据
//                DispatchQueue.main.async{
//                    self.textView.text = text
//                }
            }
            if let pace = pedometerData?.currentPace {
                text += "pace=\(pace.intValue)"
            }
            if let distance = pedometerData?.distance {
                text += "distance=\(distance.intValue)"
            }
            if let err = error {
                text += err.localizedDescription
            }
            rp(text)
            if self.isWalking {
                LocalNotificationManager.shared.sendNotification(title: "边走边看很危险！", subtitle: nil, body: "step=\(self.numberOfSteps)", launchIn: 0.1)
            }
            completion?(self.isWalking)
        }
    }
    
//    /// 检测当前是否在走路 （达咩）
//    private let motionActivityManager = CMMotionActivityManager()
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
