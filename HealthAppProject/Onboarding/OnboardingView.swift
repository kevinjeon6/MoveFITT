//
//  OnboardingView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/16/23.
//

import SwiftUI

struct OnboardingView: View {
    
    //The true value will only be added to the property when the app does not find the onboarding key previously set in the device's permanent storage
    @AppStorage("onboarding") var isOnboardingViewShowing: Bool = true
    @EnvironmentObject var vm: HealthStoreViewModel
  
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
                                .foregroundColor(.darkModeColor)
                        }
                    }
            } else {
            
                    Button {
                        vm.requestUserAuthorization()
                        isOnboardingViewShowing = false
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.tangBlue)
                                .frame(height: 48)
                            Text("Connect")
                                .foregroundColor(.darkModeColor)
                        }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .foregroundColor(.black)
        .background(
            LinearGradient(colors: [.tangBlue, .white], startPoint: .top, endPoint: .bottom)
        )

        
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(HealthStoreViewModel())
            .preferredColorScheme(.dark
            )
    }
}
