//
//  AppDelegate.swift
//  Runner
//
//  Created by Insider on 8.01.2026.
//

import Flutter
import UIKit
import firebase_messaging

@main @objc public final class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    public override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // The app delegate stays the notification center delegate so Flutter forwards
        // every callback to all plugins (Insider and Firebase alike). Firebase must still be
        // configured before this method returns because UIScene apps register plugins later.
        UNUserNotificationCenter.current().delegate = self
        FLTFirebaseMessagingPlugin.configureNotificationCenterDelegate()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    public func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
}
