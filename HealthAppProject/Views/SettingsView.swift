//
//  SettingsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    

    @Binding var stepGoal: Int
    @Binding var exerciseDayGoal: Int
    @Binding var exerciseWeeklyGoal: Int
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    @StateObject var notificationManager = NotificationManager()
    
    
    var body: some View {
        NavigationStack {
            Form {
                //MARK: Step Goal
                Section {
                    Stepper("\(stepGoal) steps", value: $healthStoreVM.stepGoal, in: 100...15_000, step: 100)
                        .foregroundColor(.blue)
                } header: {
                    Text("Set your Daily Step Goal Here")
                }
                
                //MARK: Exercise Daily Goal
                Section {
                    Stepper("\(exerciseDayGoal)", value: $healthStoreVM.exerciseDayGoal, in: 5...75, step: 5)
                    
                    Stepper("\(exerciseWeeklyGoal)", value: $healthStoreVM.exerciseWeeklyGoal, in: 75...450, step: 15)
                    
                    
                } header: {
                    Text("Set your Exercise Goals Here")
                }
                .foregroundColor(.blue)
                
                
                Section {
                    Toggle("Notifications", isOn: notificationManager.$isNotificationOn)
                        .toggleStyle(.switch)
                        .tint(.purple)
                        .onChange(of: notificationManager.isNotificationOn) { newValue in
                            notificationManager.requestUserAuthorization()
                        }
                       
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(stepGoal: Binding.constant(7500), exerciseDayGoal: Binding.constant(30), exerciseWeeklyGoal: Binding.constant(150), healthStoreVM: HealthStoreViewModel(), notificationManager: NotificationManager())
    }
}
