//
//  AppDelegate.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var StoryBoardIdentifier: String = "Main"
    var options: [NSObject: AnyObject]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register for Push Notitications, if running iOS 8
        self.options = launchOptions
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(userNotificationTypes)
            application.registerForRemoteNotifications()
        } else {
            let types = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(types)
        }
        
        //Override point for customization after application launch.
        //UINavigationBar.appearance().barTintColor = UIColor(red: 237.0/255.0, green: 196.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        UINavigationBar.appearance().tintColor = UIColor(red: 154.0/255.0, green: 30.0/255.0, blue: 236.0/255.0, alpha: 1.0) //UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 154.0/255.0, green: 30.0/255.0, blue: 236.0/255.0, alpha: 1.0),NSFontAttributeName : UIFont(name: "Didot-Italic", size:21)!]
        
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Lobster 1.4", size: 34)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //UITabBar.appearance().barTintColor = UIColor(red: 237.0/255.0, green: 196.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        UITabBar.appearance().tintColor = UIColor(red: 154.0/255.0, green: 30.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        //UITabBar.appearance().barStyle = UIBarStyle.Black
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.redColor()
        //pageController.backgroundColor = UIColor.whiteColor()
        
        
        // Initialise PayPall with client ID's 
        PayPalMobile.initializeWithClientIdsForEnvironments(
            [PayPalEnvironmentProduction: "AaRilcxXSxAxxn4kSV-FB1yMUPJMG55rwzkasOem6Kbpm3J69CketY7jv-6cuyA1N1nWFdEq-jdTRpSq",
                PayPalEnvironmentSandbox: "AWrBaasCeN1PzPGGxsuXlue5LVcZm98at3Cc8PuZqx7RZhZExtEzLZOfNebcSo-LBmvYNrhv-tGtf5mR"]
        )
        
        // Init Live Cart Controller
        LiveCartController.sharedInstance()
        
        // Check if app launch from push notification
        /*if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            self.application(UIApplication.sharedApplication(), didReceiveRemoteNotification: remoteNotification as! [NSObject : AnyObject])
        }*/
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.onquantum.CoreDataTest" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("IlluminCoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("IlluminCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            /*var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")*/
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    // Push notifications callback
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //let dataString = NSString(data: deviceToken, encoding: NSUTF8StringEncoding) as! String
        print(String(deviceToken))
        var token = String(deviceToken).subStringFrom(1)
        token = token.substringToIndex(token.endIndex.predecessor())
        //print("APN Device token : " + token)
        if let currentToken = DBApnToken.GetToken() {
            if !(currentToken as NSString).isEqualToString(token) {
                DBApnToken.SaveApnToken(token)
            }
        } else {
            DBApnToken.SaveApnToken(token)
            if UserController.sharedInstance().isAnonimous() {
                UserApnToken.SaveUserApnToken(nil, token: token, completeHandler: {() in })
            } else {
                UserApnToken.SaveUserApnToken(UserController.sharedInstance().getUser()?.ID, token: token, completeHandler: {() in })
            }
            if !DBApnToken.IsSuccessSubmited() {
                if UserController.sharedInstance().isAnonimous() {
                    UserApnToken.SaveUserApnToken(nil, token: token, completeHandler: {() in })
                } else {
                    UserApnToken.SaveUserApnToken(UserController.sharedInstance().getUser()?.ID, token: token, completeHandler: {() in })
                }
            }
        }
        /*DBApnToken.SaveApnToken(token)
        if UserController.sharedInstance().isAnonimous() {
            UserApnToken.SaveUserApnToken(nil, token: token, completeHandler: {() in })
        } else {
            UserApnToken.SaveUserApnToken(UserController.sharedInstance().getUser()?.ID, token: token, completeHandler: {() in })
        }*/
    }

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //print("Receive Remote Notification :  " + String(userInfo))
        
        if let app = userInfo["aps"] as? NSDictionary {
            let simpleNotification = SimpleNotification()
            simpleNotification.payload = String(userInfo)
            
            if let alert = app["alert"] as? String {
                simpleNotification.message = alert
            }
            if let url = app["url"] as? String {
                simpleNotification.url = url
            }
            if let targetID = Int64((app["targetID"] as? String)!) {
                simpleNotification.targetID = targetID
            }
            if let type = Int64((app["type"] as? String)!) {
                simpleNotification.type = NotificatioinType(rawValue: type)!
            }
            if let title = app["title"] as? String {
                simpleNotification.title = title
            }
            DBNotifications.SaveNotification(simpleNotification)
            
            dispatch_async(dispatch_get_main_queue(), {
                var message: String = "Remote notification"
                if !simpleNotification.title.isEmpty {
                    message = simpleNotification.title
                }
                let importantAlert: UIAlertController = UIAlertController(title: "Notification", message: message + String(userInfo.count), preferredStyle: .ActionSheet)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
                importantAlert.addAction(cancelAction)
                let viewAction: UIAlertAction = UIAlertAction(title: "Open", style: .Default) { action -> Void in
                    print("Open action")
                    let storyBoard: UIStoryboard = UIStoryboard(name: self.StoryBoardIdentifier, bundle: nil)
                    let notificationViewController = storyBoard.instantiateViewControllerWithIdentifier("NotificationNavigationController") as! UINavigationController
                    self.window?.rootViewController?.presentViewController(notificationViewController, animated: true, completion: nil)
                }
                importantAlert.addAction(viewAction)
                self.window?.rootViewController?.presentViewController(importantAlert, animated: true, completion: nil)
            })
        }
    }
}

