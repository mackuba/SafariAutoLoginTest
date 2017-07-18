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
    @IBOutlet weak var authenticateButton: UIButton!

    var safari: SFSafariViewController?
    var authSession: NSObject?

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

        if #available(iOS 11.0, *) {
            authenticateButton.isEnabled = true
        }
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

    @IBAction func authenticateButtonPressed() {
        if #available(iOS 11.0, *) {
            let url = URL(string: "http://localhost:8000/?redirect")!
            let session = SFAuthenticationSession(url: url, callbackURLScheme: "svclogintest") { (url, error) in
                print("url = \(String(describing: url))")
                print("error = \(String(describing: error))")

                if let url = url {
                    URLHandler().handleURL(url: url)
                }
            }
            session.start()
            self.authSession = session
        }
    }
}
