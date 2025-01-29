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
    @State private var isShowingWhatsNew = false

    var body: some View {
        TabView(selection: $settingsVM.selectedTab) {
            
            Tab("Dashboard", systemImage: "rectangle.grid.2x2.fill", value: 1) {
                DashboardScreen()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Supplements", systemImage: "cross.circle.fill", value: 2) {
                SupplementsView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Workouts", systemImage: "dumbbell.fill", value: 3) {
                WorkoutHistoryView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
    
            Tab("Settings", systemImage: "slider.horizontal.3", value: 4) {
                SettingsView()
                    .toolbarBackground(.primary, for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .sheet(isPresented: $isShowingWhatsNew) { WhatsNewView() }
        .onAppear { checkForUpdate() }
    }
    
    // MARK: - Methods
    
    /// Get's the current version of the App
    /// - Returns: The string of the current version of the app based from the Info.plist
    func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        return appVersion
    }
    
    /// Check if the app has been started after update
    func checkForUpdate() {
        let version = getCurrentAppVersion()
        let savedVersion = UserDefaults.standard.string(forKey: "savedVersion")
        
        if savedVersion == version {
            print("App is up to date")
        } else {
            isShowingWhatsNew.toggle()
            UserDefaults.standard.set(version, forKey: "savedVersion")
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
