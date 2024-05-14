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
//    @StateObject var healthStore = HealthStoreViewModel()
//    @EnvironmentObject var healthStore: HealthStoreViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        TabView(selection: $settingsVM.selectedTab) {
            
            QuickView()
                .tabItem {
                    Label("Summary", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            StatsView()
                .tabItem {
                    Label("Physical Activity", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
            
            //The MainScreen is the parent view and settingsview is the child view. The source of truth is coming from the ViewModel
            SettingsView(
                stepGoal: $settingsVM.stepGoal,
                exerciseDayGoal: $settingsVM.exerciseDayGoal,
                exerciseWeeklyGoal: $settingsVM.exerciseWeeklyGoal,
                muscleWeeklyGoal: $settingsVM.muscleWeeklyGoal
              )
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(3)
            
            MuscleView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(4)
            
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(.darkModeColor)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
            .environmentObject(SettingsViewModel())
    }
}
