//
//  AppDelegate.swift
//  NC3 Geofencing
//
//  Created by Novelia Refinda on 18/09/19.
//  Copyright © 2019 Novelia Refinda. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate

{

    var window: UIWindow?
    
    //STEP 1
    //ADD CENTER PROPERTY (UNTUK NOTIFICATION CENTER)
    var notificationCenter = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // STEP 2
        // untuk delegate notif
        
        self.notificationCenter = UNUserNotificationCenter.current()
        self.notificationCenter.delegate = self
        
        //STEP 3
        //define what do you need permission to use (untuk user privacy WAJIB PAKE)
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        //request permission
        notificationCenter.requestAuthorization(options: options)
        { (granted, error) in
            if !granted
            {
                print("Permission not Granted")
            }
        }
        
        
        return true
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    //STEP 4
    //pas muncul notif apa yg terjadi
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //when app is open and in fore ground
        withCompletionHandler([.alert, .sound])
    }
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler: @escaping () -> Void)
     {
        //get notif indengtifier to respond accordingly
        let identifier = response.notification.request.identifier
        
    }
    
    
    
}

