//
//  DailyOverviewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/19/24.
//

import SwiftUI

struct DailyOverviewView: View {
    
    @Environment(HealthKitViewModel.self) var healthKitVM
    @EnvironmentObject var settingsVM: SettingsViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Overview")
                .foregroundStyle(.white)
                .font(.title2.weight(.semibold))
            
            
            DailyView(
                imageText: "figure.walk",
                imageColor: .cyan,
                metricText: "steps",
                currentValue: Int(healthKitVM.currentStepCount),
                goalText: settingsVM.stepGoal,
                goalPercent: (Int(healthKitVM.currentStepCount) * 100 / settingsVM.stepGoal),
                gradientColor: [ .cyan,.blue]
            )
            
            DailyView(
                imageText: "stopwatch",
                imageColor: .green,
                metricText: "min",
                currentValue: Int(healthKitVM.currentExerciseTime),
                goalText: settingsVM.exerciseDayGoal,
                goalPercent: (Int(healthKitVM.currentExerciseTime) * 100 / settingsVM.exerciseDayGoal),
                gradientColor: [.mint, .green]
            )
            
            DailyView(
                imageText: "flame.fill",
                imageColor: .orange,
                metricText: "kcal",
                currentValue: Int(healthKitVM.currentKcalsBurned),
                goalText: settingsVM.kcalsBurnedDailyGoal,
                goalPercent: (Int(healthKitVM.currentKcalsBurned) * 100 / settingsVM.kcalsBurnedDailyGoal),
                gradientColor: [.yellow, .orange]
            )
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(#colorLiteral(red: 0.1353680193, green: 0.1355423033, blue: 0.1408430636, alpha: 1)))
        )
    }
}

#Preview {
    DailyOverviewView()
        .environment(HealthKitViewModel())
        .environmentObject(SettingsViewModel())
}
