//
//  MainScreenView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import SwiftUI

///The MainScreen is the parent view and settingsview is the child view. The source of truth is coming from the ViewModel
struct MainScreenView: View {
    
    @Environment(HealthKitViewModel.self) private var healthKitVM
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        TabView(selection: $settingsVM.selectedTab) {
            
            Tab("Dashboard", systemImage: "rectangle.grid.2x2.fill", value: 1) {
                DashboardScreen()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            
            Tab("Workouts", systemImage: "dumbbell.fill", value: 2) {
                WorkoutHistoryView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Learn", systemImage: "book.fill", value: 3) {
                InfoView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Settings", systemImage: "slider.horizontal.3", value: 4) {
                SettingsView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }

        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
            .environment(HealthKitViewModel())
            .environmentObject(SettingsViewModel())
    }
}
