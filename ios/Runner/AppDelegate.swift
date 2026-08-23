import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import UserNotifications
// import Firebase
import flutter_callkit_incoming
import PushKit
import AVFAudio
import CallKit



@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAy1EmmZYXtEjbDPvV7gIW0Qs2oD6WKi2o")
    GeneratedPluginRegistrant.register(with: self)

    // Required for foreground notification presentation and background delivery.
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    application.registerForRemoteNotifications()

    // FirebaseAppDelegateProxyEnabled is false in Info.plist,
    // so APNS/FCM wiring must be done manually.
    Messaging.messaging().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    Messaging.messaging().appDidReceiveMessage(userInfo)
    super.application(
      application,
      didReceiveRemoteNotification: userInfo,
      fetchCompletionHandler: completionHandler
    )
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 [iOS] FCM token: \(fcmToken ?? "nil")")
  }
}
