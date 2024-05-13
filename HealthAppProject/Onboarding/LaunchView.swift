//
//  LaunchView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/25/23.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var healthKitVM = HealthKitViewModel()
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
 
    
    var body: some View {
        if isOnboardingViewShowing {
            OnboardingView()
                .environment(healthKitVM)
        } else {
            MainScreenView()
                .environment(healthKitVM)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
