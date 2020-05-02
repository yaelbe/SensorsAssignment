//
//  AppDelegate.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    var sensorrsManager  = SensorsManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let rayWenderlichColor = UIColor(red: 0/255, green: 104/255, blue: 55/255, alpha: 1)
        UITabBar.appearance().tintColor = rayWenderlichColor
        UNUserNotificationCenter.current().delegate = self
        sensorrsManager.config()
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                print("Permission granted: \(granted)")
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

