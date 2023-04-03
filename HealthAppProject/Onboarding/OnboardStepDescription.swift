//
//  OnboardStepDescription.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 4/2/23.
//

import SwiftUI

struct OnboardStepDescription: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(HealthInfoText.onboardingStepCountDescription)
                .font(.title2)
        }
    }
}

struct OnboardStepDescription_Previews: PreviewProvider {
    static var previews: some View {
        OnboardStepDescription()
    }
}
