import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Pengingat lokal: tampilkan notifikasi juga saat aplikasi di foreground.
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    excludeAppDataFromBackup()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Data kesehatan & foto progres tidak ikut cadangan iCloud/komputer:
  /// basis data (Documents) dan foto (Application Support) ditandai
  /// exclude-from-backup. Penanda pada folder berlaku untuk isinya.
  private func excludeAppDataFromBackup() {
    let fm = FileManager.default
    for dir in [FileManager.SearchPathDirectory.documentDirectory, .applicationSupportDirectory] {
      guard var url = fm.urls(for: dir, in: .userDomainMask).first else { continue }
      try? fm.createDirectory(at: url, withIntermediateDirectories: true)
      var values = URLResourceValues()
      values.isExcludedFromBackup = true
      try? url.setResourceValues(values)
    }
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
