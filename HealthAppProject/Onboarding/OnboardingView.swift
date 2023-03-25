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
                
                VStack(spacing: 20) {
                    Text(HealthInfoText.physicalActivityDescription)
                    Text(HealthInfoText.strengthActivityDescription)
                    Text("It is recommended that individuals aim for 30 minutes of physical activity a day. If you are unable to perform 30 continous minutes of physical activity, you can split it up into three separate 10 minute bouts.")
                    
                    Text("You can change your goals in the \"Settings\" tab.")
                    Text("Your initial goals are set to 10,000 steps per day, Muscle strengthening activity goal is set to 2, and your weekly goal is set to 150 minutes per week. ")
                }
                .padding()
                
                
                
                VStack {
                    Text("To get started and start setting your goals, please authorize")
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            
            // MARK: Button
            
            Button {
                if onBoardingTabSelection == 0 {
                    onBoardingTabSelection = 1
                   
                } else {
                    vm.requestUserAuthorization()
                    isOnboardingViewShowing = false
                }
                
            } label: {
                    Text(onBoardingTabSelection == 0 ? "Next" : "Request Authorization")
                }
                    
            }
        }
    }


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(HealthStoreViewModel())
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("workout-st")
                .resizable()
                .scaledToFit()
            
            Text("Welcome to the \"Health App\". This is to help keep track of hitting your physical activity recommendation and meet the muscle strengthening activity recommendation")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
