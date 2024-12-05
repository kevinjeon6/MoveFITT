//
//  WeeklyOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/19/24.
//

import SwiftUI

struct WeeklyOverviewView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    
    var meetGoal: Bool {
        if healthKitVM.strengthActivityWeekCount.count >= 2 {
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Overview")
                .foregroundStyle(.white)
                .font(.title2.weight(.semibold))
            
            HStack(spacing: 30){
                VStack(alignment: .leading, spacing: 4) {
                    Text("Strength Traning")
                        .font(.title2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    
                    HStack {
                        Text("Goal: \(healthKitVM.strengthActivityWeekCount.count)/\(settingsVM.muscleWeeklyGoal)")
                        Image(systemName: meetGoal ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(meetGoal ? .green : . white)
                    }
                    .font(.subheadline)
                    .padding(.bottom)
                    
                    Text("Physical Activity")
                        .font(.title2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    

                    Text("\(Int(healthKitVM.weekTotalTime))/\(settingsVM.exerciseWeeklyGoal)")
                        .font(.subheadline)
                }
                
                Spacer()

                WeeklyPAChartView(healthKitVM: healthKitVM)

                Spacer()
            }
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.white)
        //.frame(height: 192)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
        )
    }
}

#Preview {
    WeeklyOverviewView()
        .environment(HealthKitViewModel())
        .environmentObject(SettingsViewModel())
}
