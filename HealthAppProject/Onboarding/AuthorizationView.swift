//
//  AuthorizationView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/31/23.
//

import SwiftUI

struct AuthorizationView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(.appleHealthIcon)
                .resizable()
                .frame(width: 90, height: 90)
                .shadow(color: .gray.opacity(0.3), radius: 16)
                .padding(.bottom, 12)
            
            Text("Connect to Apple Health to hit your goals")
                .font(.title3.bold())
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
