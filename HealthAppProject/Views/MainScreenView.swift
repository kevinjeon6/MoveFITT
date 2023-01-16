//
//  MainScreenView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/15/23.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var healthStore = HealthStoreViewModel()
    
    
    var body: some View {
        TabView {
            
            ContentView(healthStore: healthStore)
                .tabItem {
                    Label("Today", systemImage: "list.bullet.clipboard")
                }
            
            StatsView(healthStoreVM: healthStore)
                .tabItem {
                    Label("Statistics", systemImage: "chart.xyaxis.line")
                }
            
            Text("Settings view?")
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
