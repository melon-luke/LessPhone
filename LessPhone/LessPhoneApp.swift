//
//  LessPhoneApp.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/3.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        KeepAliveManager.shared.appKill()
        // app 即将被杀死
        rp("log-applicationWillTerminate")
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}

class SceneDelegate: NSObject, ObservableObject, UIWindowSceneDelegate {
    var window: UIWindow?   // << contract of `UIWindowSceneDelegate`
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = windowScene.keyWindow   // << store !!!
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // app 即将被杀死
    }
}

@main
struct LessPhoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    let coreDataManager = CoreDataManager.shared
    @State var backTaskId: UIBackgroundTaskIdentifier?
        
    init() {
        KeepAliveManager.shared.run()
        _ = EventBus.shared
        _ = Storage.shared
        _ = LocalNotificationManager.shared
        _ = Statistics.shared
    }
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newScenePhase in
            
            switch newScenePhase {
            case .active:
                rp("active")
                
                EventBus.shared.appActive(true)
            case .inactive:
                EventBus.shared.appActive(false)
                rp("inactive")
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//                    guard let self = self else { return }
                    let timeRemianing = UIApplication.shared.backgroundTimeRemaining
                    rp("backgroundTimeRemaining\(timeRemianing)")
                }
                backTaskId = UIApplication.shared.beginBackgroundTask (withName: "Finish Network Tasks") {
                    rp("forcefinish")
                }
                
            case .background:
                rp("background")
//                rp("backgroundTimeRemaining\(UIApplication.shared.backgroundTimeRemaining)")
            @unknown default:
                rp("default")
            }
        }
    }

//    func cpuLoadTask() {
//        for i in 0...100000000 {
//            rp("cpuLoadTask\(i)s")
//            rp("backgroundTimeRemaining\(UIApplication.shared.backgroundTimeRemaining)")
//            sleep(1)
//        }
//    }
}
