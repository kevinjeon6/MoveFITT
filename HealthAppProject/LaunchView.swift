//
//  LaunchView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/25/23.
//

import SwiftUI

struct LaunchView: View {

    @StateObject var healthStoreVM = HealthStoreViewModel()
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
 
    
    var body: some View {
        if isOnboardingViewShowing {
            OnboardingView()
                .environmentObject(healthStoreVM)
        } else {
            MainScreenView()
                .environmentObject(healthStoreVM)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
