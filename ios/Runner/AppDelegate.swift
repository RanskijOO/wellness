import FirebaseCore
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    configureFirebaseIfNeeded()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func configureFirebaseIfNeeded() {
    guard FirebaseApp.app() == nil else {
      return
    }

    // Configure Firebase only when the native plist is available.
    guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
      return
    }

    FirebaseApp.configure()
  }
}
