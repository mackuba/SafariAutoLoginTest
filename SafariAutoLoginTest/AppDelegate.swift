//
//  AppDelegate.swift
//  SafariAutoLoginTest
//
//  Created by Kuba Suder on 18.08.2015.
//  Copyright © 2015 Kuba Suder. All rights reserved.
//

import UIKit

let NameLinkReceivedNotification = "NameLinkReceivedNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if url.host == "name" {
            let path = url.path! as NSString

            NSNotificationCenter.defaultCenter().postNotificationName(NameLinkReceivedNotification,
                object: self,
                userInfo: ["name": path.substringFromIndex(1)]
            )
        }

        return true
    }
}
