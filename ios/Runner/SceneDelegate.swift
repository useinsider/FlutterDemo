//
//  SceneDelegate.swift
//  Runner
//
//  Created by Insider on 8.01.2026.
//

import Flutter
import InsiderMobile
import UIKit

public final class SceneDelegate: FlutterSceneDelegate {

    public override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        for urlContext in connectionOptions.urlContexts {
            Insider.handle(urlContext.url)
        }
    }
}
