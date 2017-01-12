//
//  AppDelegate.swift
//  A_simple_TODO_list
//
//  Created by Kun Tai KAO on 1/12/17.
//  Copyright © 2017 Kun Tai KAO. All rights reserved.
//

import UIKit
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var navigationController: UINavigationController!
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		self.navigationController = application.windows[0].rootViewController as! UINavigationController
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
		self.loadTasks()
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
	
	func loadTasks() {
        if (isConnectedToNetwork() == true)
        {
        let URL: NSString = "https://sheetsu.com/apis/v1.0/7decfd275eca"
		
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		HTTPClient.request(URL, method: "GET", body: "", callback: {
			(resultObject: AnyObject?, error: Bool, errorMessage: NSString) -> Void in
			
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			
			if error == false {
				//There is no error. Process data
				taskManager.tasks = [Task]()
				for item in resultObject as! NSArray {
					taskManager.addTask(Task(values: item as! NSDictionary))
				}
				
				let mainViewController = self.navigationController.viewControllers[0] as! MainViewController
				mainViewController.tasksTable.reloadData()
			} else {
				//There was an error. Show the corresponding message
				let alertController = UIAlertController(title: "Error", message: errorMessage as String, preferredStyle: UIAlertControllerStyle.Alert)
				alertController.addAction(UIAlertAction(title: NSLocalizedString("OK_LABEL", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
				self.navigationController.presentViewController(alertController, animated: true, completion: nil)
			}
		})
        }
        else{
            
        }
	}
}

