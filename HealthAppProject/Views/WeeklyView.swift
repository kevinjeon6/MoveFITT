//
//  WeeklyView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/15/24.
//

import SwiftUI

struct WeeklyView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Strength Traning")
            HStack {
                Text("Goal: 0/2")
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
            .padding(.bottom)
            
            Text("Physical Activity")
            HStack {
                Text("200/350")
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 25)
    }
}

#Preview {
    WeeklyView()
}
