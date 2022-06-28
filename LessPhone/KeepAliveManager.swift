//
//  LocationManager.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/3.
//

import Foundation
import CoreLocation
import Combine

class KeepAliveManager: NSObject, ObservableObject {
    static let shared = KeepAliveManager()
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func run() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func appKill() {
        LocalNotificationManager.shared.sendNotification(title: "请不要关掉我！", subtitle: nil, body: "强制退出后将无法统计到你的屏幕使用时间，点击重新打开", launchIn: 0.1)
    }
}

extension KeepAliveManager: CLLocationManagerDelegate {
    private var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}
