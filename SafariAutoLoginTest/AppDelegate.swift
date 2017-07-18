//
//  AppDelegate.swift
//  SafariAutoLoginTest
//
//  Created by Kuba Suder on 18.08.2015.
//  Copyright © 2015 Kuba Suder. All rights reserved.
//

import UIKit

let NameLinkReceivedNotification = Notification.Name("NameLinkReceivedNotification")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "name" {
            let path = url.path as NSString

            NotificationCenter.default.post(
                name: NameLinkReceivedNotification,
                object: self,
                userInfo: ["name": path.substring(from: 1)]
            )
        }

        return true
    }
}
