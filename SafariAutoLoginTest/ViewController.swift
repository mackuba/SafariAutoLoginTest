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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(nameLinkReceived),
            name: NameLinkReceivedNotification,
            object: nil
        )

        let safari = SFSafariViewController(url: URL(string: "http://localhost:8000/?redirect")!)
        safari.delegate = self
        safari.modalPresentationStyle = .overCurrentContext
        safari.view.alpha = 0.05

        self.safari = safari
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let safari = safari {
            present(safari, animated: false, completion: nil)
        }
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        dismiss(animated: false, completion: nil)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.safari = nil
    }

    func nameLinkReceived(_ notification: Notification) {
        if let info = notification.userInfo, let name = info["name"] as? String {
            if !name.isEmpty {
                nameLabel.text = "You are \(name)!"
            } else {
                nameLabel.text = "I don't know who you are :("
            }
        }
    }
}
