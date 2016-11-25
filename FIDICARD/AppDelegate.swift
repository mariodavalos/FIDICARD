//
//  AppDelegate.swift
//  FIDICARD
//
//  Created by omar on 07/09/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import FacebookShare
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseMessaging
import FirebaseInstanceID


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var landscape = false


     func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        registerForPushNotifications(application)
        application.registerForRemoteNotifications()

        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(self.tokenRefreshNotification),
        name: kFIRInstanceIDTokenRefreshNotification,
        object: nil)
        
        FIRApp.configure()
        
        // Check if launched from notification
        if (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject]) != nil {
            // 2
        }
        /////
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("InicioViewController")
        if let userName = NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), let pass = NSUserDefaults.standardUserDefaults().stringForKey("password") {
            
            if userName != "" && pass != "" {
                    
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userLogged")
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("HomeView")

             }
        }

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    }
    

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        
        
        
        print(userInfo)
        /*
        if (userInfo["titulo"] != nil && userInfo["mensaje"] != nil){
            
            let notification = UILocalNotification()
            notification.alertBody = userInfo["titulo"] as? String // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = NSDate.init() // todo item due date (when notification will be fired). immediately here
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        */
        //
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj = defaults.dataForKey("user") where defaults.boolForKey("userLogged") {
                
                if let user = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? Usuario {
                    
                    if let objeto = defaults.dataForKey("\(user.email!)notificaciones") {
                        
                        if let Notificaciones = NSKeyedUnarchiver.unarchiveObjectWithData(objeto) as? [CPromocion] {
                                
                                ArregloPromociones.promociones = Notificaciones
                                let notificacion = CPromocion()
                                notificacion.titulo = userInfo["titulo"] as? String
                                notificacion.desc_corta = userInfo["mensaje"] as? String
                                notificacion.cuerpo = userInfo["mensaje"] as? String
                                ArregloPromociones.promociones.append(notificacion)
                            
                                //Badge
                                var badge = defaults.integerForKey("\(user.email!)badge")
                                badge += 1
                                defaults.setInteger(badge, forKey: "\(user.email!)badge")
                            
                                let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
                                NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(user.email!)notificaciones")
                                defaults.synchronize()
                        }
                    }
                    else {
                        
                        ArregloPromociones.promociones = [CPromocion]()
                        let notificacion = CPromocion()
                        notificacion.titulo = userInfo["titulo"] as? String
                        notificacion.desc_corta = userInfo["mensaje"] as? String
                        notificacion.cuerpo = userInfo["mensaje"] as? String
                        ArregloPromociones.promociones.append(notificacion)
                        
                        //Badge
                        var badge = defaults.integerForKey("\(user.email!)badge")
                        badge += 1
                        defaults.setInteger(badge, forKey: "\(user.email!)badge")
                        
                        let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
                        NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(user.email!)notificaciones")
                        defaults.synchronize()

                    }
                    
                }

            }
        
    
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print(userInfo)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj = defaults.dataForKey("user") where defaults.boolForKey("userLogged") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? Usuario {
                
                if let objeto = defaults.dataForKey("\(user.email!)notificaciones") {
                    
                    if let Notificaciones = NSKeyedUnarchiver.unarchiveObjectWithData(objeto) as? [CPromocion] {
                        
                        
                        var badge = defaults.integerForKey("\(user.email!)badge")
                        badge += 1
                        ArregloPromociones.promociones = Notificaciones
                        let notificacion = CPromocion()
                        notificacion.titulo = userInfo["titulo"] as? String
                        notificacion.desc_corta = userInfo["mensaje"] as? String
                        notificacion.cuerpo = userInfo["mensaje"] as? String
                        ArregloPromociones.promociones.append(notificacion)
                        let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
                        NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(user.email!)notificaciones")
                        defaults.setInteger(badge, forKey: "\(user.email!)badge")
                        defaults.synchronize()
                    }
                }
                else {
                    var badge = defaults.integerForKey("\(user.email!)badge")
                    badge += 1
                    ArregloPromociones.promociones = [CPromocion]()
                    let notificacion = CPromocion()
                    notificacion.titulo = userInfo["titulo"] as? String
                    notificacion.desc_corta = userInfo["mensaje"] as? String
                    notificacion.cuerpo = userInfo["mensaje"] as? String
                    ArregloPromociones.promociones.append(notificacion)
                    let myData = NSKeyedArchiver.archivedDataWithRootObject(ArregloPromociones.promociones)
                    NSUserDefaults.standardUserDefaults().setObject(myData, forKey: "\(user.email!)notificaciones")
                    defaults.setInteger(badge, forKey: "\(user.email!)badge")
                    defaults.synchronize()
                    
                }
                
            }
            
        }

        
    }

    
    func registerForPushNotifications(application: UIApplication) {
        
        
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let obj = defaults.dataForKey("user") where defaults.boolForKey("userLogged") {
            
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(obj) as? Usuario {
                
                let badge = defaults.integerForKey("\(user.email!)badge")
                if badge > 0 {
                    
                 application.applicationIconBadgeNumber = badge
                    
                }
                
               

            }
        }
        
        
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
        if let token = FIRInstanceID.instanceID().token() {
        print(FIRInstanceID.instanceID().token()!)
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        
        }
       
        connectToFcm()
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        
    }
    

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }

    
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return self.landscape ? .LandscapeRight : .Portrait
    }
    
    
    

 
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]

    func applicationDidEnterBackground(application: UIApplication) {
       
        FIRMessaging.messaging().disconnect()

    
    }


    func applicationDidBecomeActive(application: UIApplication) {
       
        FBSDKAppEvents.activateApp()
        self.connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {

        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
        
    }
    
    
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }

        NSUserDefaults.standardUserDefaults().setObject(FIRInstanceID.instanceID().token()!, forKey: "token")
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    
    



}

