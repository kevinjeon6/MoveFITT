//
//  OnboardTextView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/31/23.
//

import SwiftUI

struct OnboardTextView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("• " + HealthInfoText.onboardingPhysicalActivityDescription)
            Text("• " + HealthInfoText.onboardingStrengthActivityDescription)
            Text("• " + HealthInfoText.onboardingStepCountDescription)
            Text("• " + "You can change your goals in the \"Settings\" tab")

       
  
            Spacer()
        }
        .font(.title3)
        .padding(.vertical, 30)
        .padding(.horizontal)
    }
}

struct OnboardTextView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardTextView()
    }
}
