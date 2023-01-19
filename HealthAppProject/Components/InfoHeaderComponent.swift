//
//  InfoHeaderComponent.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/18/23.
//

import SwiftUI

struct InfoHeaderComponent: View {
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
                .frame(width: 120, height: 6)
                .foregroundColor(.secondary)
                .opacity(0.2)
            
        }
    }
}

struct InfoHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        InfoHeaderComponent()
    }
}
