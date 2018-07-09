//
//  AppDelegate.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/5/19.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FBSDKCoreKit
import UserNotifications
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,  GIDSignInDelegate {

    var window: UIWindow?
    let userdefault = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login_way = userdefault.string(forKey: "login_way")
        if login_way == "FB" || login_way == "Google"{
            let initialVC = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.window?.rootViewController = initialVC
        }else{
            let initialVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.window?.rootViewController = initialVC
        }
        self.window?.makeKeyAndVisible()

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
//        if #available(iOS 10, *){
//            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
//                application.registerForRemoteNotifications()
//            }
//        }else{
//            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
//            UIApplication.shared.registerForRemoteNotifications()
//            
//        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
        Thread.sleep(forTimeInterval: 1)    // time for launchscreen exist
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled;
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if error != nil {
                    return
                }
                self.userdefault.set(authResult?.user.uid, forKey: "uid")
                self.userdefault.set("Google", forKey: "login_way")
                self.userdefault.set("ok", forKey: "nextVC")
                if let profile = authResult?.additionalUserInfo?.profile{
//                    if let picture = profile["picture"] as? NSDictionary,
//                        let data = picture["data"] as? NSDictionary,
//                        let url = data["url"] as? String{
                        print("profile",profile)
//                    }
                }
            }
        }
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


}

