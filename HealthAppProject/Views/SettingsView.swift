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
                } header: {
                    Text("Set your Daily Step Goal Here")
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.gray.opacity(0.3))
                
                //MARK: Exercise Daily Goal
                Section {
                    Stepper("Daily Goal: \(settingsVM.exerciseDayGoal)", value: $settingsVM.exerciseDayGoal, in: 5...75, step: 5)
                    
                    Stepper("Weekly Goal: \(settingsVM.exerciseWeeklyGoal)", value: $settingsVM.exerciseWeeklyGoal, in: 75...450, step: 15)

                    
                    Stepper("Strength Goal: \(settingsVM.muscleWeeklyGoal)", value: $settingsVM.muscleWeeklyGoal, in: 2...7, step: 1)

                    
                    Stepper("Kcal Goal: \(settingsVM.kcalsBurnedDailyGoal)", value: $settingsVM.kcalsBurnedDailyGoal, in: 100...2000, step: 25)
                    
                } header: {
                    Text("Set your Exercise Goals Here")
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.gray.opacity(0.3))
                
                List {
                    NavigationLink {
                        InfoView()
                    } label: {
                        Text("Learn About Your Goals")
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Color.gray.opacity(0.3))
 
                }
            }
            .background(Color.black)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
    }
    
    
    init() {
        ///Logic to display the navigation title to White
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        ///Logic to display the plus and minus to a color. When changing to a dark background, the plus/minus blended in.
        ///To change the actual color you use the tint() modifier
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
