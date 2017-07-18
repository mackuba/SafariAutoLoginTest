# Safari auto-login (iOS 9)

This demo shows how you can automatically log in users to your iOS app after they install it based on cookies previously set in Safari. The idea is that if you have a way of logging them in somewhere in the browser before they download your app, or they have previously logged in to your webapp before installing it, you can automatically recognize them without them having to go through an in-app login flow and enter the same login info again.

This project was inspired by [this article by LaunchKit](https://library.launchkit.io/how-ios-9-s-safari-view-controller-could-completely-change-your-app-s-onboarding-experience-2bcf2305137f).

**== UPDATE 2017 ==**

The original approach doesn't work anymore - some people of course had to use it for evil purposes (surprise surprise) and Apple has changed a few things:

- the [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) (5.1.1) now specifically say that:

  > SafariViewContoller must be used to visibly present information to users; the controller may not be hidden or obscured by other views or layers. Additionally, an app may not use SafariViewController to track users without their knowledge and consent.

- since iOS 10, SafariViewController doesn't seem to load at all when alpha is set to 0
- since iOS 11, SafariViewController uses a separate cookie storage from Safari, so even if you manage to make it load, it won't recognize you

Possible alternatives:

- [Shared Web Credentials](https://developer.apple.com/documentation/security/shared_web_credentials) (if the user uses iCloud Keychain)
- [SFAuthenticationSession](https://developer.apple.com/documentation/safariservices/sfauthenticationsession), a new API added in iOS 11 beta 3 (also supports e.g. 1Password, but loses some of the "magic" of automatically recognizing the user)
- one popular third party service that uses fingerprinting and other shady techniques, but please don't use that 🙏

I've added support for `SFAuthenticationSession` in the app - you can launch it by tapping the "Authenticate" button. It's actually pretty nice and the result is very similar to the old approach, except you get a popup first where you have to confirm access and then you see the SVC slide up and down.

## See it in action

Here's how it looks:

<a href="https://vimeo.com/136968596"><img src="http://f.cl.ly/items/2F1y0Y3v0C0U401m0i0C/safari_autologin.png" width="600" alt="video"></a>


## How it's done

It's actually pretty simple:

- the app creates an `SFSafariViewController` at startup and tells it to load a special page in your webapp that automatically redirects back to your app using a custom URL scheme (you can only pass something back to your app with a redirect, since the app has no direct access to the contents of the Safari View Controller)
- the main view controller presents the Safari View Controller as a popup (it needs to be displayed to start loading the page), but to hide the Safari View Controller from the user, it sets its `modalPresentationStyle` to `.OverCurrentContext` and its view's `alpha` to 0
  * update: alpha now needs to be [at least 0.05](https://github.com/mackuba/SafariAutoLoginTest/issues/6)
  * you might also be able to get it to work with a [second UIWindow](https://github.com/mackuba/SafariAutoLoginTest/issues/5)
- the page reads the name from the previously set cookie and redirects to `svclogintest://name/yournamehere`; that triggers the callback `application(handleOpenURL:)` in the application delegate, which notifies the view controller about it through an `NSNotification`
  * you could also use [universal app links](https://github.com/mackuba/SafariAutoLoginTest/issues/3) for this, which would avoid a possible issue with some other app using the same URL scheme as yours, accidentally or on purpose
- when the page finishes loading, the view controller automatically cleans up the SVC
- when the view controller receives the notification from the delegate, it updates the label in the center with the user's name

So this way you can remember the user between app installations and even before it's installed for the first time, as long as you control the site which sets the cookies and can make it redirect to the custom URL, and as long as the user doesn't clear the cookies in Safari. (I've seen an issue though where even after clearing the cookies the SVC was still seeing them, even though Safari didn't - might be a bug in the beta?)

For the new 2017 version using `SFAuthenticationSession`:

- the app creates an `SFAuthenticationSession` and saves it in an instance variable (otherwise the popup disappears immediately)
- it tells is to load exactly the same URL as in SVC and launches it by calling `start()`
  * anyone knows how to change the "(null)" in the message that's shown in the popup? or what the `callbackURLScheme` is for, since it seems to work just fine regardless what you put there?
- if authentication succeeds, you get a URL which you can handle the same way as in `application(handleOpenURL:)`, if not, you get an error object


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
