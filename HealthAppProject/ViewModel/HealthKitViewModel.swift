//
//  HealthKitViewModel.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 5/9/24.
//

import HealthKit
import Foundation
import Observation

@Observable
class HealthKitViewModel {
    
    ///Create HealthKit store
    let healthStore = HKHealthStore()
    
    // MARK: - Health Data Types
    
    let allTypes: Set = [
        HKQuantityType(.stepCount),
        HKQuantityType(.restingHeartRate),
        HKQuantityType(.heartRateVariabilitySDNN),
        HKQuantityType(.appleExerciseTime),
        HKQuantityType(.activeEnergyBurned),
        HKWorkoutType.workoutType()
    ]
    
    
}
