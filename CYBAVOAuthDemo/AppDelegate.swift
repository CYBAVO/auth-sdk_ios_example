//
//  AppDelegate.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/14.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import SwiftEventBus
var PushDeviceToken = ""
import UserNotifications
import Firebase
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDefaultsFromSettingsBundle()
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIUtil.colorPrimary
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        return true
    }
    func registerDefaultsFromSettingsBundle()
    {
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]
        
        var defaultsToRegister = Dictionary<String, Any>()
        
        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                continue
            }
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        print("Device Token: \(PushDeviceToken)")
        if(ServiceHolder.get().getPairings().count > 0){
            ServiceHolder.get().setPushToken(pushToken: PushDeviceToken){result in
                switch result {
                   case .success(_):
                        print("setPushToken success")
                    break
                    case .failure(let error):
                        print("setPushToken onFailed\(error)")
                    break
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
        ) {
        print("recive: \(userInfo)")
        guard let data = userInfo["data"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        guard let jsonBody = data["jsonBody"] as? [String: String] else {
            completionHandler(.failed)
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "New action"
        content.body = ""
        content.badge = 1
        content.sound = UNNotificationSound.default
        print("didReceiveRemoteNotification \(content.title)_\(content.body)")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        SwiftEventBus.post("fetch2fa")
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive", response.notification.request.content)
        completionHandler()
   }
       
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       print("willPresent", notification.request.content)
       completionHandler([])

   }

}

extension AppDelegate: MessagingDelegate {
 
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = messaging.apnsToken?.reduce("") {
            return $0 + String(format: "%02x", $1)
        }

        print("Device APNs Push Token: \(String(describing: token))")
        print("Device FCM Token: \(String(describing: fcmToken))")
        if let fcmToken = fcmToken {
            PushDeviceToken = fcmToken
        }
    }
    
}
