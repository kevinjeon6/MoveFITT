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
    var caloriesBurnedQuery: HKStatisticsCollectionQuery?
    
    @Published var steps: [Step] = [Step]()
    @Published var restingHR: [RestingHeartRate] = [RestingHeartRate]()
    @Published var kcalBurned: [CaloriesBurned] = [CaloriesBurned]()
    @Published var exerciseTime: [ExerciseTime] = [ExerciseTime]()
    @Published var exerciseTimeMonth: [ExerciseTime] = [ExerciseTime]()
    @Published var exerciseTime3Months: [ExerciseTime] = [ExerciseTime]()
    
    
    //Associated with the segmented control. Week is set as the default
    @Published var timePeriodSelected = "week"
    
    //Select tab that is active
    @Published var selectedTab = 1
    
    //AppStorage key name is step goal
    //In general, since using AppStorage. Can update variable directly. Can then put code in any view on app and it'll have the same access to the same variable
    @AppStorage(Constants.stepGoal) var stepGoal: Int = 10_000
    @AppStorage(Constants.exerciseWeeklyGoal)var exerciseWeeklyGoal: Int = 150
    @AppStorage(Constants.exerciseDailyGoal)var exerciseDayGoal: Int = 30
    
    var currentStepCount: Int {
        steps.last?.count ?? 0
    }
    
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
    
    var weeklyExTime: Int {
        exerciseTime.reduce(0) { $0 + $1.exerValue }
    }
    
    var exerTimeDescription: String {
        "It is recommended that individuals engage in 150 min/week of physical activity. Meeting the recommended guidelines may reduces heart attack incidences and "
    }
    
    
    var currentKcalsBurned: Int {
        kcalBurned.last?.kcal ?? 0
    }
 
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            requestUserAuthorization()
        } else {
            print("HealthKit is unavailable on this platform")
        }
    }
    
    
    //MARK: - Request User Authorization for Health Data
    func requestUserAuthorization() {
    
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let healthTypes = Set([stepType, restingHeartRateType, exerciseTimeType, caloriesBurnedType])
        
        
        guard let healthStore = self.healthStore else {
            //returning false
            return
        }
        
        
        //Passing in an empty array for toShare since we are not writing any data yet. Want to read the user's data
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in

            if success {
                self.calculateStepCountData()
                self.calculateRestingHRData()
                self.calculateSevenDaysExerciseTime()
                self.calculateMonthExerciseTime()
                self.calculate3MonthExerciseTime()
                self.calculateCaloriesBurned()
            }
        }
    }
    
    //MARK: - Calculate Data for One Week
    func calculateStepCountData() {
        
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        //Set up anchor date. Which starts on a Monday at 12:00 AM
        let anchorDate = Date.sundayAt12AM()
        
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
    
    func calculateRestingHRData() {
        let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        
        
        let anchorDate = Date.sundayAt12AM()
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
    
    
    //MARK: Active energy burned
    func calculateCaloriesBurned() {
        
        
        let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        //Set up anchor date. Which starts on a Monday at 12:00 AM
        let anchorDate = Date.sundayAt12AM()
        
        //Set up daily to calculate health data daily
        let daily = DateComponents(day: 1)
        
        //Go Back 7 days. This is the start date
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        
        //Define the predicate
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        //MARK: - Query for Step Count
        caloriesBurnedQuery = HKStatisticsCollectionQuery(quantityType: caloriesBurnedType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        //Setting the results handler
      caloriesBurnedQuery!.initialResultsHandler = {
            calorieBurnedQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                if let kcalquantity = statistics.sumQuantity() {
                    let kcaldate = statistics.startDate
                    let kcalValue = kcalquantity.doubleValue(for: .kilocalorie())
                    let kcals = CaloriesBurned(kcal: Int(kcalValue), date: kcaldate)
                    
                   
                    DispatchQueue.main.async {
                        self.kcalBurned.append(kcals)
                     
                    }
                }
            }
        }
        
        //Gets called when there's any new data that's coming into the database
        caloriesBurnedQuery!.statisticsUpdateHandler = {
            calorieBurnedQuery, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                if let kcalquantity = statistics.sumQuantity() {
                    let kcaldate = statistics.startDate
                    let kcalValue = kcalquantity.doubleValue(for: .kilocalorie())
                    let kcals = CaloriesBurned(kcal: Int(kcalValue), date: kcaldate)
                    
                    DispatchQueue.main.async {
                        self.kcalBurned.append(kcals)
                    }
                }
            }
        }
        
        //Execute our query.
        guard let caloriesBurnedQuery = self.caloriesBurnedQuery else { return }
        self.healthStore?.execute(caloriesBurnedQuery)
    }
    
    
    
    
    
    //MARK: One Week
    func calculateSevenDaysExerciseTime() {
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        //Go Back 7 days. This is the start date
        let date = Date()
        let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: date)?.start
//        Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate!)
        
        
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
            statisticsCollection.enumerateStatistics(from: startDate!, to: endDate ?? Date()) { statistics, stop in
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
        
        
        exerciseTimeQuery!.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: startDate!, to: endDate ?? Date()) { statistics, stop in
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
    
    func calculateMonthExerciseTime() {
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
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
                        self.exerciseTimeMonth.append(exTime)
                    }
                }
            }
        }
       
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    
    //MARK: Three Months
    
    func calculate3MonthExerciseTime(){
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        let startDate = Calendar.current.date(byAdding: DateComponents(day: -89), to: Date())!
        
        
        let predicate = HKQuery.predicateForSamples(withStart: threeMonthsAgo, end: nil, options: .strictStartDate)

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
                        self.exerciseTime3Months.append(exTime)
                    }
                }
            }
        }
     
        
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    
    }
}
  

