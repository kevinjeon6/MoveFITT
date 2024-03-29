//
//  SettingsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    @Binding var stepGoal: Int
    @Binding var exerciseDayGoal: Int
    @Binding var exerciseWeeklyGoal: Int
    @Binding var muscleWeeklyGoal: Int
    @State private var isShowingInfoSheet = false
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                //MARK: Step Goal
                Section {
                    Stepper("\(stepGoal) steps", value: $healthStoreVM.stepGoal, in: 5_000...15_000, step: 100)
                        .foregroundColor(.blue)
                } header: {
                    Text("Set your Daily Step Goal Here")
                }
                
                //MARK: Exercise Daily Goal
                Section {
                    Stepper("Daily Goal: \(exerciseDayGoal)", value: $healthStoreVM.exerciseDayGoal, in: 5...75, step: 5)
                        .foregroundColor(.blue)
                    
                    Stepper("Weekly Goal: \(exerciseWeeklyGoal)", value: $healthStoreVM.exerciseWeeklyGoal, in: 75...450, step: 15)
                        .foregroundColor(.blue)
                    
                    Stepper("Strength Goal: \(muscleWeeklyGoal)", value: $healthStoreVM.muscleWeeklyGoal, in: 2...7, step: 1)
                        .foregroundColor(.blue)
                    
                    
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
        SettingsView(stepGoal: Binding.constant(7500), exerciseDayGoal: Binding.constant(30), exerciseWeeklyGoal: Binding.constant(150), muscleWeeklyGoal: Binding.constant(2))
            .environmentObject(HealthStoreViewModel())
    }
}
