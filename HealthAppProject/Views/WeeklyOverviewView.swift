//
//  WeeklyOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/19/24.
//

import SwiftUI

struct WeeklyOverviewView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Overview")
                .foregroundStyle(.white)
                .font(.title2.weight(.semibold))
            
            WeeklyView()
        }
        .foregroundStyle(.white)
        //.frame(height: 192)
        .padding(.horizontal)
    }
}

#Preview {
    WeeklyOverviewView()
}
