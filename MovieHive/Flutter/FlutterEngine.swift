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
    let flutterEngine = FlutterEngine(name: "flutter-engine")
    
    init() {
        flutterEngine.run()
        // If you added a plugin to Flutter module, you also need to register plugin to flutter engine
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }
}
