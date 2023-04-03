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
            Text("To get started, please authorize")
                .font(.title2)        
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
