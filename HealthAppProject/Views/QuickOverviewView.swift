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
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Overview")
                    .foregroundStyle(.white)
                    .font(.title2.weight(.semibold))
                    .padding([.leading])

                 
                HStack {
                    Image(systemName: "figure.walk")
                        .foregroundStyle(.cyan)
                    Text("4,000 / 10,000 steps")
                        .foregroundStyle(.white)
                }
                .padding(.leading)
                HStack {
                    ProgressionStepBar(value: 5000, goalValue: 10_000)
                    Text("50%")
                        .layoutPriority(1)
                        .foregroundStyle(.white)
                }
                
                
                
                HStack {
                    Image(systemName: "stopwatch")
                        .foregroundStyle(.green)
                    Text("20 / 30 mins")
                        .foregroundStyle(.white)
                }
                .padding(.leading)
                HStack {
                    ProgressionStepBar(value: 5000, goalValue: 10_000)
                    Text("50%")
                        .layoutPriority(1)
                        .foregroundStyle(.white)
                }
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("555 / 1000 kcals ")
                        .foregroundStyle(.white)
                }
                .padding(.leading)
                HStack {
                    ProgressionStepBar(value: 5000, goalValue: 10_000)
                    Text("50%")
                        .layoutPriority(1)
                        .foregroundStyle(.white)
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
                
            )
            .padding()
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
