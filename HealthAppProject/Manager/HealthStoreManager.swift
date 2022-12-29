//
//  HealthStoreVM.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import Foundation

class HealthStoreManager: ObservableObject {
    
    var healthStore: HKHealthStore?
    
 
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        } else {
            print("HealthKit is unavailable on this platform")
        }
    }
    
    
    //MARK: - Request User Authorization for Health Data
    func requestUserAuthorization(completion: @escaping (Bool) -> Void) {
        
        let healthTypes = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        
        ])
        
        guard let healthStore = self.healthStore else {
            //returning false
            return
        }
        
      
      //Passing in an empty array for toShare since we are not writing any data yet. Want to read the user's data
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in
            completion(success)
        }
    }
    
}
