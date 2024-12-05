//
//  SettingsViewModel.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 5/14/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    //Associated with the segmented control. Week is set as the default
    @Published var timePeriodSelected = "week"
    
    //Select tab that is active
    @Published var selectedTab = 1
    
    //AppStorage key name is step goal
    //In general, since using AppStorage. Can update variable directly. Can then put code in any view on app and it'll have the same access to the same variable
    @AppStorage(Constants.stepGoal) var stepGoal: Int = 10_000
    @AppStorage(Constants.exerciseWeeklyGoal) var exerciseWeeklyGoal: Int = 150
    @AppStorage(Constants.exerciseDailyGoal) var exerciseDayGoal: Int = 30
    @AppStorage(Constants.kcalBurnedDailyGoal) var kcalsBurnedDailyGoal: Int = 250
    @AppStorage(Constants.muscleStrengtheningWeeklyGoal) var muscleWeeklyGoal: Int = 2
}
