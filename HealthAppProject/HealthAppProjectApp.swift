//
//  HealthAppProjectApp.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import SwiftUI

@main
struct HealthAppProjectApp: App {
    
    @StateObject var vm = HealthStoreViewModel()
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingViewShowing {
                OnboardingView()
                    .environmentObject(vm)
            } else {
                MainScreenView()
                    .environmentObject(vm)
            }
        }
    }
}
