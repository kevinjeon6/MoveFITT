//
//  WeeklyOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/19/24.
//

import SwiftUI

struct WeeklyOverviewView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Overview")
                .foregroundStyle(.white)
                .font(.title2.weight(.semibold))
            
            WeeklyView(
                progress: 2,
                minValue: 0,
                maxValue: 3,
                title: 2,
                color: .green
            )
        }
        .foregroundStyle(.white)
        //.frame(height: 192)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1))
                     )
        )
    }
}

#Preview {
    WeeklyOverviewView()
}
