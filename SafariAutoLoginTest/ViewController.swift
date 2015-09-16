//
//  ViewController.swift
//  SafariAutoLoginTest
//
//  Created by Kuba Suder on 18.08.2015.
//  Copyright © 2015 Kuba Suder. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!

    var safari: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "nameLinkReceived:",
            name: NameLinkReceivedNotification,
            object: nil)

        let safari = SFSafariViewController(URL: NSURL(string: "http://localhost:8000/?redirect")!)
        safari.delegate = self
        safari.modalPresentationStyle = .OverCurrentContext
        safari.view.alpha = 0.0

        self.safari = safari
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let safari = safari {
            presentViewController(safari, animated: false, completion: nil)
        }
    }

    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        dismissViewControllerAnimated(false, completion: nil)
    }

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(false, completion: nil)
        self.safari = nil
    }

    func nameLinkReceived(notification: NSNotification) {
        if let info = notification.userInfo, name = info["name"] as? String {
            if !name.isEmpty {
                nameLabel.text = "You are \(name)!"
            } else {
                nameLabel.text = "I don't know who you are :("
            }
            if let safari = self.safari {
                safariViewControllerDidFinish(safari)
            }
        }
    }
}
