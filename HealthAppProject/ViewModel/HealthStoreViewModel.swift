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
    
    var currentRestHR: Int {
        restingHR.last?.restingValue ?? 0
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
    func calculateStepCountData() {
        
        
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        //Set up anchor date. Which starts on a Monday at 12:00 AM
        let anchorDate = Date.mondayAt12AM()
        
        //Set up daily to calculate health data daily
        let daily = DateComponents(day: 1)
        
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date()) ?? Date()
        
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
            
            statisticsCollection.enumerateStatistics(from: oneWeekAgo, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: .count())
                    let step = Step(count: Int(value), date: date)
                    
                    
                    
                    DispatchQueue.main.async {
                        self.steps.append(step)
                    }
                }
            }
        }
        
        //Execute our query.
        guard let query = self.query else { return }
        self.healthStore?.execute(query)
    }
    
    
    
    func calculateRestingHRData() {
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date()) ?? Date()
        
        
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        //        let restingHRanchorDate = Calendar.current.startOfDay(for: Date())
        //        let hourly = DateComponents(hour: 1)
        //        let oneDayCount = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())

        restingHRquery =   HKStatisticsCollectionQuery(quantityType: restingHeartRateType,
                                                       quantitySamplePredicate: predicate,
                                                       options: .discreteAverage,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
        //
        //
        //        //        HKAnchoredObjectQuery(type: restingHeartRateType, predicate: predicate, anchor: anchorDate, limit: HKObjectQueryNoLimit, resultsHandler: <#T##(HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void#>)
        //
        //
        //
        //
        restingHRquery!.initialResultsHandler = {
            restingQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating resting HR
            statisticsCollection.enumerateStatistics(from: oneWeekAgo, to: Date()) { statistics, stop in
                if let restHRquantity = statistics.averageQuantity() {
                    let hrdate = statistics.startDate
                    
                    //HR Units
                    let hrUnit = HKUnit(from: "count/min")
                    let restHRvalue = restHRquantity.doubleValue(for: hrUnit)
                    let restHR = RestingHeartRate(restingValue: Int(restHRvalue), date: hrdate)
                    
                    DispatchQueue.main.async {
                        self.restingHR.append(restHR)
                    }
                }
            }
        }
        
        
        guard let restingHRquery = self.restingHRquery else { return }
        self.healthStore?.execute(restingHRquery)
    }
    
}
  

