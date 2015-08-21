# Safari auto-login (iOS 9)

This demo shows how you can automatically log in users to your iOS app after they install it based on cookies previously set in Safari. The idea is that if you have a way of logging them in somewhere in the browser before they download your app, or they have previously logged in to your webapp before installing it, you can automatically recognize them without them having to go through an in-app login flow and enter the same login info again.

This project was inspired by [this article by LaunchKit](https://library.launchkit.io/how-ios-9-s-safari-view-controller-could-completely-change-your-app-s-onboarding-experience-2bcf2305137f).


## See it in action

Here's how it looks:

<a href="https://vimeo.com/136968596"><img src="http://f.cl.ly/items/2F1y0Y3v0C0U401m0i0C/safari_autologin.png" width="600" alt="video"></a>


## How it's done

It's actually pretty simple:

- the app creates an `SFSafariViewController` at startup and tells it to load a special page in your webapp that automatically redirects back to your app using a custom URL scheme (that's the only way you can pass something back to your app, since the app has no direct access to the contents of the Safari View Controller)
- the main view controller presents the Safari View Controller as a popup (it needs to be displayed to start loading the page), but to hide the Safari View Controller from the user, it sets its `modalPresentationStyle` to `.OverCurrentContext` and its view's `alpha` to 0
  * let me know if you know a better way to do this :)
- the page reads the name from the previously set cookie and redirects to `svclogintest://name/yournamehere`; that triggers the callback `application(handleOpenURL:)` in the application delegate, which notifies the view controller about it through an `NSNotification`
- when the page finishes loading, the view controller automatically cleans up the SVC
- when the view controller receives the notification from the delegate, it updates the label in the center with the user's name

So this way you can remember the user between app installations and even before it's installed for the first time, as long as you control the site which sets the cookies and can make it redirect to the custom URL, and as long as the user doesn't clear the cookies in Safari. (I've seen an issue though where even after clearing the cookies the SVC was still seeing them, even though Safari didn't - might be a bug in the beta?)


## How to test it

- download or clone the project
- in a terminal, go into the project's directory and start an HTTP server in that folder:

        python -m SimpleHTTPServer

- open the project in Xcode 7
- build & run
- to log in & out, go to `http://localhost:8000` in Safari in the simulator and use the form to update the name


## Credits / license

Created by Kuba Suder, licensed under WTFPL license.

If you have any suggestions or comments, please let me know via Twitter [@kuba_suder](https://twitter.com/kuba_suder), email or GitHub issues.

Note: please don't use this for any evil purposes 🙏
