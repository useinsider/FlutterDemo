//
//  AppDelegate.swift
//  Runner
//
//  Created by Insider on 8.01.2026.
//

import Flutter
import UIKit

@main @objc public final class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    public override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    public func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
}
