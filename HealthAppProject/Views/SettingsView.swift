//
//  SettingsView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    @State var stepGoal: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("\(stepGoal) steps", value: $stepGoal, in: 100...15_000, step: 100)
                        .foregroundColor(.blue)
                } header: {
                    Text("Set your Step Goal Here")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(stepGoal: 7500)
    }
}
