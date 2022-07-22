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
//        locationManager.distanceFilter = 5  // specified in meters
    }

    func run() {
        // 太费电
        AudioManager.shared.openBackgroundAudioAutoPlay = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func appKill() {
        LocalNotificationManager.shared.sendAppKill()
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
//        location.speed
//        LocalNotificationManager.shared.sendLocation(text: location.description)
        print(#function, location)
    }
}
