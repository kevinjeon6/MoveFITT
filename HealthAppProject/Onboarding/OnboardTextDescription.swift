//
//  OnboardTextDescription.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 4/7/23.
//

import SwiftUI

struct OnboardTextDescription: View {
    
    var onboardText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(onboardText)
                .font(.title2)
                .bold()
        }
    }
}

struct OnboardTextDescription_Previews: PreviewProvider {
    static var previews: some View {
        OnboardTextDescription(onboardText: "PA is good for the body")
    }
}
