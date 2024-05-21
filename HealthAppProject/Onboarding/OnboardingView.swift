//
//  OnboardingView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/16/23.
//

import HealthKitUI
import SwiftUI

struct OnboardingView: View {
    
    //The true value will only be added to the property when the app does not find the onboarding key previously set in the device's permanent storage
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
    @Environment(HealthKitViewModel.self) var healthKitVM
    @Environment(\.dismiss) private var dismiss
    @State private var trigger = false
    @State private var onBoardingTabSelection = 0
   
    
    var body: some View {
        VStack{
                TabView(selection: $onBoardingTabSelection) {
                    WelcomeView()
                        .tag(0)
                    
                    OnboardTextDescription(onboardText: HealthInfoText.onboardingPhysicalActivityDescription)
                        .tag(1)
                    
                    OnboardTextDescription(onboardText: HealthInfoText.onboardingStrengthActivityDescription)
                        .tag(2)
                    
                    OnboardTextDescription(onboardText: HealthInfoText.onboardingStepCountDescription)
                        .tag(3)
                    
                    OnboardInitialGoalDescription()
                        .tag(4)
                    
                    AuthorizationView()
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .transition(.slide)
                .animation(.default, value: onBoardingTabSelection)

            // MARK: Button
            
            if onBoardingTabSelection != 5 {
                    Button {
                        onBoardingTabSelection += 1
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.tangBlue)
                                .frame(height: 48)
                            
                            Text("Next")
                                .font(.title2.bold())
                                .foregroundStyle(Color.darkModeColor) 
                        }
                    }
                    .accessibilityAddTraits(.isButton)
            } else {
                Button {
                    ///Check that Health data is available on the user's device
                    if HKHealthStore.isHealthDataAvailable() {
                        trigger = true
                    }
                    isOnboardingViewShowing = false
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.tangBlue)
                            .frame(height: 48)
                        Text("Connect")
                            .font(.title2.bold())
                            .foregroundStyle(Color.darkModeColor)
                    }
                }
                .accessibilityAddTraits(.isButton)
                .healthDataAccessRequest(
                    store: healthKitVM.healthStore,
                    readTypes: healthKitVM.allTypes,
                    trigger: trigger) { result in
                    switch result {
                        
                    case .success(_):
                        print("Access to HealthKit is successful")
                        Task {
                           await healthKitVM.displayData()
                        }
//                        dismiss()
                    case .failure(_):
                        print("Cannot access to HealthKit")
                        dismiss()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .foregroundStyle(.black)
        .background(
            LinearGradient(colors: [.tangBlue, .white], startPoint: .top, endPoint: .bottom)
        )

        
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environment(HealthKitViewModel())
            .preferredColorScheme(.dark)
    }
}
