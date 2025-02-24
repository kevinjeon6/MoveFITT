//
//  OnboardInitialGoalDescription.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 4/2/23.
//

import SwiftUI

struct OnboardInitialGoalDescription: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(HealthInfoText.onboardingInitialGoalDescription)
            Text("You can change your goals in the \"Settings\" tab")
        }
        .font(.title3.bold())
    }
}

struct OnboardInitialGoalDescription_Previews: PreviewProvider {
    static var previews: some View {
        OnboardInitialGoalDescription()
    }
}
