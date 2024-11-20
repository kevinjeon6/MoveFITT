//
//  DailyOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/19/24.
//

import SwiftUI

struct DailyOverviewView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Overview")
                .foregroundStyle(.white)
                .font(.title2.weight(.semibold))
            
            
            DailyView(
                imageText: "figure.walk",
                imageColor: .cyan,
                metricText: "steps",
                currentValue: 10_000,
                goalText: 10_000,
                goalPercent: 100,
                gradientColor: [ .cyan,.blue]
            )
            
            DailyView(
                imageText: "stopwatch",
                imageColor: .green,
                metricText: "min",
                currentValue: 25,
                goalText: 30,
                goalPercent: 75,
                gradientColor: [.mint, .green]
            )
            
            DailyView(
                imageText: "flame.fill",
                imageColor: .orange,
                metricText: "kcal",
                currentValue: 150,
                goalText: 500,
                goalPercent: 25,
                gradientColor: [.yellow, .orange]
            )
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
}

#Preview {
    DailyOverviewView()
}
