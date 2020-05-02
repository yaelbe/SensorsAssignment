//
//  SensorrsManager.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 03/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications
import CoreMotion

class SensorsManager : NSObject, UNUserNotificationCenterDelegate{
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    var timer : Timer = Timer()
    var gravityZ = Queue()
    
    func config(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.04 //25 HZ
            motionManager.startDeviceMotionUpdates(to: queue){ [weak self](motion, error) in
               if let motion = motion{
                self?.gravityZ.enqueue(motion.gravity.z)
                    if self?.gravityZ.count == 50, let sum = self?.gravityZ.sum , sum >= 4{
                        let content = UNMutableNotificationContent()
                        content.title = "Gravity Z 📍"
                        content.body = "The z - axis average value is above 4G"
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
                        
                        self?.center.add(request, withCompletionHandler: nil)
                    }
                }
            }
        }
        
        self.timer = Timer(fire: Date(), interval: 1.0, repeats: true,
                           block: { (timer) in
                            if let data = self.motionManager.accelerometerData {
                                LocationsStorage.shared.saveLastMotion(data)
                            }
        })
    }
}

extension SensorsManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        LocationsStorage.shared.saveDataOnDisk(location)

    }
}

