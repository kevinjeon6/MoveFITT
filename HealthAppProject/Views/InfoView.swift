//
//  InfoView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/18/23.
//

import SwiftUI

struct InfoView: View {
    
    var description: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
        
            InfoHeaderComponent()
            
            Text(description)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            Spacer()
            
        }
        .padding(.top, 25)
        .padding(.horizontal)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(description: "This is some description text")
    }
}
