//
//  swiftful_swiftui_practiceApp.swift
//  swiftful-swiftui-practice
//
//  Created by Andres Rechimon on 26/05/2024.
//

import SwiftUI
import SwiftfulRouting

@main
struct SwiftfulSwiftUIinPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                ContentView()
            }
        }
    }
}
