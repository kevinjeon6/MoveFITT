//
//  WelcomeView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/31/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            //Need to update image for actual app. Current image is a placeholder
            Image("workout-st")
                .resizable()
                .scaledToFit()
            
            Text("Welcome to the MoveFITT. This is to help keep track of hitting your physical activity recommendation and meet the muscle strengthening activity recommendation")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
