//
//  AppDelegate.swift
//  LPES
//
//  Created by Emil Stoychev on 3/29/18.
//  Copyright © 2018 Emil Stoychev. All rights reserved.
//

import UIKit
import CoreData
import AirshipKit
#if DEBUG
    import AdSupport
#endif
import Leanplum
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /* ––– UAirship Start ––– */
        UAirship.takeOff()
        UAirship.push().userPushNotificationsEnabled = true
        UAirship.push().defaultPresentationOptions = [.alert, .badge, .sound]
        
        UAirship.namedUser().identifier = "emil-stoychev"
        UAirship.push().addTags(["gender_male", "age_31", "email_emil.sp@gmail.com"])
        UAirship.push().updateRegistration()
        
        let productAddedToCartEvent = UACustomEvent(name: "added_product_to_cart")
        productAddedToCartEvent.setStringProperty("XX-123", forKey: "productID")
        productAddedToCartEvent.track()
        
        let productPurchasedEvent = UACustomEvent(name: "purchased_product")
        productPurchasedEvent.setStringProperty("XX-123", forKey: "productID")
        productPurchasedEvent.track()
        /* ––– UAirship End ––– */

        /* ––– Leanplum Start ––– */
        #if DEBUG
            Leanplum.setDeviceId(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
            Leanplum.setAppId("app_h4mOpAzrY0Cw9Xp4e9Q9BGKOg8SfrUHXClP4Nq3cZN8",
                              withDevelopmentKey:"dev_BBb9fRjv1K5hdOoYYZnSeJ4mEShmH1yKCUGGMp5ItLc")
        #else
            Leanplum.setAppId("app_h4mOpAzrY0Cw9Xp4e9Q9BGKOg8SfrUHXClP4Nq3cZN8",
                              withProductionKey: "prod_sfaapQmHIJ9UNdcdfqjGFzDYRsct9gHACCeleNg4oqg")
        #endif
        
        // Starts a new session and updates the app content from Leanplum.
        Leanplum.start(withUserId: "emil-stoychev",
                       userAttributes: ["gender":"male",
                                        "age": 31,
                                        "email":"emil.sp@gmail.com", "name": "Emil"])
        
        Leanplum.track("added_product_to_cart", withInfo: "XX-123")
        
        Leanplum.track("purchased_product", withInfo: "XX-123")
        /* ––– Leanplum End ––– */
        
        /* ––– Firebase Start ––– */
        FirebaseApp.configure()
        
        Analytics.setUserProperty("male", forName: "gender")
        Analytics.setUserProperty("31", forName: "age")
        Analytics.setUserProperty("emil.sp@gmail.com", forName: "email")
        
        Analytics.logEvent("added_product_to_cart", parameters: [
            "productID": "XX-123" as NSObject
            ])
        Analytics.logEvent("purchased_product", parameters: [
            "productID": "XX-123" as NSObject
            ])
        
        /* ––– Firebase End ––– */
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LPES")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

