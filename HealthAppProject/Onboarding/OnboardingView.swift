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
                    
                    OnboardInitialGoalDescription()
                        .tag(1)
                    
                    AuthorizationView()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .transition(.slide)
                .animation(.default, value: onBoardingTabSelection)

            // MARK: Button
            
            if onBoardingTabSelection != 2 {
                    Button {
                        onBoardingTabSelection += 1
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(.white)
                                .frame(height: 48)
                            
                            Text("Next")
                                .font(.title2.bold())
                                .foregroundStyle(.black)
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
                            .fill(.pink)
                            .frame(height: 48)
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Connect")
                                .font(.title2.bold())
                        }
                        .foregroundStyle(.white)
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
                             await healthKitVM.displayAll()
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
        .foregroundStyle(.white)
        .background(
            Color.black
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
