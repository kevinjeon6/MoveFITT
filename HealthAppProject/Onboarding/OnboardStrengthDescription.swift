//
//  OnboardStrengthDescription.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 4/2/23.
//

import SwiftUI

struct OnboardStrengthDescription: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(HealthInfoText.onboardingStrengthActivityDescription)
                .font(.title2)
        }
    }
}

struct OnboardStrengthDescription_Previews: PreviewProvider {
    static var previews: some View {
        OnboardStrengthDescription()
    }
}
