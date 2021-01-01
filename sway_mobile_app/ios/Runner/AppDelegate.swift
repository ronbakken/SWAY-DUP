import UIKit
import Flutter
// import Firebase
// import AppCenter
// import AppCenterAnalytics
// import AppCenterCrashes

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // FirebaseApp.configure()
    // INF Sandbox App Center API key
    // MSAppCenter.start("c011adf3-8607-41bf-855a-4476b212ceb4", withServices:[
    //   MSAnalytics.self,
    //   MSCrashes.self
    // ])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
