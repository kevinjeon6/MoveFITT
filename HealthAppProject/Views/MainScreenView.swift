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
                    Label("Summary", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            StatsView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Physical Activity", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
            
            //The MainScreen is the parent view and settingsview is the child view. The source of truth is coming from the ViewModel
            SettingsView(
                stepGoal: $healthStore.stepGoal,
                exerciseDayGoal: $healthStore.exerciseDayGoal,
                exerciseWeeklyGoal: $healthStore.exerciseWeeklyGoal,
                muscleWeeklyGoal: $healthStore.muscleWeeklyGoal,
                healthStoreVM: healthStore)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(3)
            
            MuscleView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(4)
            
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(.white.opacity(0.9))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
