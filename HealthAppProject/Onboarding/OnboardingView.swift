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
                
                OnboardTextView()
                    .tag(1)
         
            
                AuthorizationView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            
            // MARK: Button
            
            Button {
                if onBoardingTabSelection == 0 {
                    onBoardingTabSelection = 1
                   
                } else {
                    //Request to read health data from user
                    vm.requestUserAuthorization()
                    isOnboardingViewShowing = false
                }
                
            } label: {
                Text(onBoardingTabSelection != 2 ? "Next" : "Request Authorization")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(.green)
            .clipShape(Capsule())
            
        }
        .padding(.horizontal)
        .padding(.bottom)
        
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(HealthStoreViewModel())
    }
}
