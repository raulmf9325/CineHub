//
//  FlutterEngine.swift
//  MovieHive
//
//  Created by Raul Mena on 5/16/24.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
    private let flutterEngine = FlutterEngine(name: "flutter-engine")
    
    private init() {
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }
    
    static let shared = FlutterDependencies()
}

extension FlutterDependencies {
    func presentFlutterModule() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
              let window = windowScene.windows.first(where: \.isKeyWindow),
              let rootViewController = window.rootViewController
        else { return }
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        
        rootViewController.present(flutterViewController, animated: true)
    }
}
