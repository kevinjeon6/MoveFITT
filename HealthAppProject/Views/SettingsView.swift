//
//  SettingsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    @EnvironmentObject var settingsVM: SettingsViewModel
    @State private var isShowingInfoSheet = false
    
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                //MARK: Step Goal
                Section {
                    Stepper("\(settingsVM.stepGoal) steps", value: $settingsVM.stepGoal, in: 5_000...15_000, step: 100)
                        .foregroundColor(.blue)
                } header: {
                    Text("Set your Daily Step Goal Here")
                }
                
                //MARK: Exercise Daily Goal
                Section {
                    Stepper("Daily Goal: \(settingsVM.exerciseDayGoal)", value: $settingsVM.exerciseDayGoal, in: 5...75, step: 5)
                        .foregroundColor(.blue)
                    
                    Stepper("Weekly Goal: \(settingsVM.exerciseWeeklyGoal)", value: $settingsVM.exerciseWeeklyGoal, in: 75...450, step: 15)
                        .foregroundColor(.blue)
                    
                    Stepper("Strength Goal: \(settingsVM.muscleWeeklyGoal)", value: $settingsVM.muscleWeeklyGoal, in: 2...7, step: 1)
                        .foregroundColor(.blue)
                    
                    Stepper("Kcal Goal: \(settingsVM.kcalsBurnedDailyGoal)", value: $settingsVM.kcalsBurnedDailyGoal, in: 100...2000, step: 25)
                        .foregroundStyle(.blue)
                    
                } header: {
                    Text("Set your Exercise Goals Here")
                }
                
                InfoView()
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
