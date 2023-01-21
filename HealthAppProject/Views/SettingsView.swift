//
//  SettingsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    

    @Binding var stepGoal: Int
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("\(stepGoal) steps", value: $healthStoreVM.stepGoal, in: 100...15_000, step: 100)
                        .foregroundColor(.blue)
                } header: {
                    Text("Set your Daily Step Goal Here")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(stepGoal: Binding.constant(7500), healthStoreVM: HealthStoreViewModel())
    }
}
