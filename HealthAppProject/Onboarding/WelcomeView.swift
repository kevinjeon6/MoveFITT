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
            Image(.welcomeIcon)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.3), radius: 16)
                .padding(.bottom, 12)
            
            Text("Track your progress towards the goals set by the Physical Activity Guidelines and get insights for heart and respiratory metrics.")
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
