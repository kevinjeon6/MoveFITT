//
//  MainScreenView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import SwiftUI

struct MainScreenView: View {
    
    //@StateObject -> Use this on creation/ init
    //@ObservedObject -> Use this for subviews
    @StateObject var healthStore = HealthStoreViewModel()

    
    
    var body: some View {
        TabView(selection: $healthStore.selectedTab) {
            
            QuickView()
                .environmentObject(HealthStoreViewModel())
                .tabItem {
                    Label("Today", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            StatsView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Exercise Stats", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
            
            //The MainScreen is the parent view and settingsview is the child view. The source of truth is coming from the ViewModel
            SettingsView(
                stepGoal: $healthStore.stepGoal,
                exerciseDayGoal: $healthStore.exerciseDayGoal,
                exerciseWeeklyGoal: $healthStore.exerciseWeeklyGoal,
                healthStoreVM: healthStore)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(3)
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
