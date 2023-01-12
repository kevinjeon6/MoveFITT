//
//  HealthStoreVM.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import Foundation

class HealthStoreViewModel: ObservableObject {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var restingHRquery: HKStatisticsCollectionQuery?
    
    @Published var steps: [Step] = [Step]()
    @Published var restingHR: [RestingHeartRate] = [RestingHeartRate]()
    
    
    var currentStepCount: Int {
        steps.last?.count ?? 0
    }
    
    var stepCountPercent: Int {
        ((currentStepCount * 100) / 10_000)
    }
 
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        } else {
            print("HealthKit is unavailable on this platform")
        }
    }
    
    
    //MARK: - Request User Authorization for Health Data
    func requestUserAuthorization(completion: @escaping (Bool) -> Void) {
        //Using one health data type to put on screen for now
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
                let healthTypes = Set([
                    stepType, restingHeartRateType
//                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
//                    HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
//                    HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
//                    HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
//                    HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        
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
    
    
    //MARK: - Calculate Data for One Week
    //Takes in a completion handler and returns an HKStatisticCollection: func calculateStepCount(completion: @escaping (HKStatisticsCollection?) -> Void)
    func calculateHealthData() {
        //Health Data I want to display in future
        //        let healthTypes = Set([
        //            HKObjectType.quantityType(forIdentifier: .stepCount)!,
        //            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        //            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        //            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
        //            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        //        ])
        
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        //Set up anchor date. Which starts on a Monday at 12:00 AM
        let anchorDate = Date.mondayAt12AM()
        
        //Set up daily to calculate health data daily
        let daily = DateComponents(day: 1)
        
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())
        
        //Define the predicate
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        //MARK: - Query for Step Count
        query = HKStatisticsCollectionQuery(quantityType: stepType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        //Setting the results handler
        query!.initialResultsHandler = {
            query, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            self.updateUIFromStatistics(statisticsCollection)
        }
        
        //MARK: - Query for Resting HR
       restingHRquery = HKStatisticsCollectionQuery(quantityType: restingHeartRateType,
                                                     quantitySamplePredicate: predicate,
                                                     options: .discreteAverage,
                                                     anchorDate: anchorDate,
                                                     intervalComponents: daily)

        

        
        restingHRquery!.initialResultsHandler = {
            restingQuery, statisticsCollection, error in

            guard let statisticsCollection = statisticsCollection else { return}

            self.updateHRUIFromStatistics(statisticsCollection)
        }
        
        //Execute our query.
        guard let query = self.query else { return }
        guard let restingHRquery = self.restingHRquery else { return }
        
        //If we succeed in our query. We execute it
        self.healthStore?.execute(query)
        self.healthStore?.execute(restingHRquery)
    }
    
    
    
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        //Since we are updating our UI, we want to dispatch back to the main thread
        DispatchQueue.main.async {
            let startDate =  Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
            let endDate = Date()
            
            //Calculating the number of steps
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    
                    //Step Units
                    let unit = HKUnit.count()
                    let value = quantity.doubleValue(for: unit)
                    let step = Step(count: Int(value), date: date)
                    self.steps.append(step)

                }
            }
        }
    }
    
    
    func updateHRUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async {
            let startDate =  Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
            let endDate = Date()
            
            //Calculating the number of steps
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    if let restHRquantity = statistics.averageQuantity() {
                        let hrdate = statistics.startDate
                        
                        //Step Units
                        let hrUnit = HKUnit(from: "count/min")
                        let restHRvalue = restHRquantity.doubleValue(for: hrUnit)
                        let restHR = RestingHeartRate(restingValue: Int(restHRvalue), date: hrdate)
                        self.restingHR.append(restHR)

                    }

                }
            }
    }
}
