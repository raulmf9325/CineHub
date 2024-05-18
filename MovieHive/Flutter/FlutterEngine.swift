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
    private init() {}
    
    static let shared = FlutterDependencies()
}

extension FlutterDependencies {
    enum Route {
        case people(Int)
    }
    
    func presentFlutterModule(route: Route) {
        let flutterEngine = FlutterEngine(name: "flutter-engine")
        let initialRoute = makeRouteString(route)
        flutterEngine.run(withEntrypoint: "main", initialRoute: initialRoute)
        
        GeneratedPluginRegistrant.register(with: flutterEngine)
        
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
    
    private func makeRouteString(_ route: Route) -> String {
        switch route {
        case .people(let id):
            return "/people?id=\(id)"
        }
    }
}
