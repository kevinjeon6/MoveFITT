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
    
    //Select tab that is active
    @State private var selectedTab = 1
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            QuickView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Today", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            
            StatsView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Statistics", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
            
            //The MainScreen is the parent view and settingsview is the child view. The source of truth is coming from the ViewModel
            SettingsView(stepGoal: $healthStore.stepGoal, healthStoreVM: healthStore)
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
