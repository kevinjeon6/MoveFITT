//
//  HealthAppProjectApp.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import SwiftUI
import SwiftData

@main
struct HealthAppProjectApp: App {
    
    @State private var healthKitVM = HealthKitViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingViewShowing {
                OnboardingView()
                    .environment(healthKitVM)
            } else {
                MainScreenView()
                    .environment(healthKitVM)
                    .environmentObject(settingsVM)
            }
        }
        .modelContainer(for: SupplementItem.self)
    }
}
