//
//  HealthStoreVM.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import Foundation
import SwiftUI

class HealthStoreViewModel: ObservableObject {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var restingHRquery: HKStatisticsCollectionQuery?
    var exerciseTimeQuery: HKStatisticsCollectionQuery?
    
    @Published var steps: [Step] = [Step]()
    @Published var restingHR: [RestingHeartRate] = [RestingHeartRate]()
    @Published var exerciseTime: [ExerciseTime] = [ExerciseTime]()
    
    
    //Associated with the segmented control. Week is set as the default
    @Published var timePeriodSelected = "week"
    
    var currentStepCount: Int {
        steps.last?.count ?? 0
    }
    
    //AppStorage key name is step goal
    //In general, since using AppStorage. Can update variable directly. Can then put code in any view on app and it'll have the same access to the same variable
    @AppStorage("step goal") var stepGoal: Int = 10_000
    
    var stepCountPercent: Int {
        ((currentStepCount * 100) / stepGoal)
    }
    
    var currentRestHR: Int {
        restingHR.last?.restingValue ?? 0
    }
    
    var restHRDescription: String {
        " Resting Heart Rate is your heart rate while resting for a period of time. Your heart is primarily controlled by sympathetic and parasympathetic input to the sinoatrial (SA) node. A "
    }
    
    var currentExTime: Int {
        exerciseTime.last?.exerValue ?? 0
    }
    
    var exerTimeDescription: String {
        "It is recommended that individuals engage in 150 min/week of physical activity. Meeting the recommended guidelines may reduces heart attack incidences and "
    }
 
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            calculateStepCountData()
            calculateRestingHRData()
            calculateExerciseTimeData()
            calculateMonthExerciseTimeData()
        } else {
            print("HealthKit is unavailable on this platform")
        }
    }
    
    
    //MARK: - Request User Authorization for Health Data
    func requestUserAuthorization(completion: @escaping (Bool) -> Void) {
    
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        let healthTypes = Set([stepType, restingHeartRateType, exerciseTimeType])
        
        
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
    func calculateStepCountData() {
        
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        //Set up anchor date. Which starts on a Monday at 12:00 AM
        let anchorDate = Date.mondayAt12AM()
        
        //Set up daily to calculate health data daily
        let daily = DateComponents(day: 1)
        
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        
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
            
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
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
        
        //Gets called when there's any new data that's coming into the database
        query!.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
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
    

//    func stopQuery() {
//        self.healthStore?.stop(query!)
//        self.healthStore?.stop(restingHRquery!)
//        self.healthStore?.stop(exerciseTimeQuery!)
//
//    }

    
    
    func calculateRestingHRData() {
        let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        
        
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        
        
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        //        let restingHRanchorDate = Calendar.current.startOfDay(for: Date())
        //        let hourly = DateComponents(hour: 1)
        //        let oneDayCount = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())

        restingHRquery =   HKStatisticsCollectionQuery(quantityType: restingHeartRateType,
                                                       quantitySamplePredicate: predicate,
                                                       options: .discreteAverage,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
   
        
        restingHRquery!.initialResultsHandler = {
            restingQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating resting HR
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
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
        
        restingHRquery!.statisticsUpdateHandler = {
            restingQuery, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating resting HR
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
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
    
    
    //MARK: One Week
    func calculateExerciseTimeData() {
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        
        
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: predicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                if let exerciseTimequantity = statistics.sumQuantity() {
                    let exerciseTimedate = statistics.startDate
                    
                    //Exercise Time
                    let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute()) 
                    let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                    
                    DispatchQueue.main.async {
                        self.exerciseTime.append(exTime)
                    }
                }
            }
        }
        
        
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    //MARK: One Month
    
    func calculateMonthExerciseTimeData() {
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        //Go Back 7 days. This is the start date
        let oneMonthAgo = Calendar.current.date(byAdding: DateComponents(day: -30), to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -29), to: Date())!
        
        
        let predicate = HKQuery.predicateForSamples(withStart: oneMonthAgo, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: predicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                if let exerciseTimequantity = statistics.sumQuantity() {
                    let exerciseTimedate = statistics.startDate
                    
                    //Exercise Time
                    let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                    let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                    
                    DispatchQueue.main.async {
                        self.exerciseTime.append(exTime)
                    }
                }
            }
        }
        
        
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    }
}
  

