//
//  OnboardTextView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/31/23.
//

import SwiftUI

struct OnboardTextView: View {
    var body: some View {
        VStack(alignment: .leading) {

            Text(HealthInfoText.onboardingPhysicalActivityDescription)
                .font(.title2)

        }
    }
}

struct OnboardTextView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardTextView()
    }
}
