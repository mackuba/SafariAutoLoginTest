//
//  URLHandler.swift
//  SafariAutoLoginTest
//
//  Created by Kuba Suder on 19.07.2017.
//  Copyright © 2017 Kuba Suder. All rights reserved.
//

import Foundation

let NameLinkReceivedNotification = Notification.Name("NameLinkReceivedNotification")

class URLHandler {
    func handleURL(url: URL) {
        if url.host == "name" {
            let path = url.path as NSString

            NotificationCenter.default.post(
                name: NameLinkReceivedNotification,
                object: self,
                userInfo: ["name": path.substring(from: 1)]
            )
        }
    }
}
