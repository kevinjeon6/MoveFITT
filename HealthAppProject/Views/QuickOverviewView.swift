//
//  QuickOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/14/24.
//

import SwiftUI

struct QuickOverviewView: View {
    
    @State private var selectedTab = 1
    var body: some View {
        TabView(selection: $selectedTab) {
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
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                
            )
            .tag(1)
            
            //TODO: Fix when creating separate views
            VStack(alignment: .leading, spacing: 4) {
                Text("Weekly Overview")
                    .foregroundStyle(.white)
                    .font(.title2.weight(.semibold))
                    .padding([.leading, .bottom])
                    .padding(.top, 10)
                
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
            .frame(height: 180)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                
            )
            .padding()
            .tag(2)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    QuickOverviewView()
}
