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
    
    // MARK: Health Types
    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
    let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
    let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    let workoutType = HKWorkoutType.workoutType()
    
    
    
    // MARK: Health Type data
    @Published var steps: [Step] = [Step]()
    @Published var restingHR: [RestingHeartRate] = [RestingHeartRate]()
    @Published var hrvHR: [HeartRateVariability] = [HeartRateVariability]()
    @Published var kcalBurned: [CaloriesBurned] = [CaloriesBurned]()
    @Published var exerciseTime: [ExerciseTime] = [ExerciseTime]()
    @Published var exerciseTime7Days: [ExerciseTime] = [ExerciseTime]()
    @Published var exerciseTimeMonth: [ExerciseTime] = [ExerciseTime]()
    @Published var exerciseTime3Months: [ExerciseTime] = [ExerciseTime]()
    @Published var muscleStrength: [HKWorkout] = [HKWorkout]()
    
    @Published var muscleYearAndMonth = [YearAndMonth: [HKWorkout]]()
    
    
    
    func updateFilteredArray(strengthStartDate: Date, strengthEndDate: Date) -> [HKWorkout] {
        muscleStrength.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate || $0.workoutActivityType.rawValue == 20  && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate)
        }
    }
    
    // MARK: Dates for calculating data
    //Set up anchor date. Which starts on a Monday at 12:00 AM
    let anchorDate = Date.sundayAt12AM()
    
    //Set up daily to calculate health data daily
    let daily = DateComponents(day: 1)
    let date = Date()
    
    //Go Back 7 days. This is the start date
    let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
    let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
    
    //    let strengthActivityWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
    
    
    
    //Associated with the segmented control. Week is set as the default
    @Published var timePeriodSelected = "week"
    
    //Select tab that is active
    @Published var selectedTab = 1
    
    //AppStorage key name is step goal
    //In general, since using AppStorage. Can update variable directly. Can then put code in any view on app and it'll have the same access to the same variable
    @AppStorage(Constants.stepGoal) var stepGoal: Int = 10_000
    @AppStorage(Constants.exerciseWeeklyGoal)var exerciseWeeklyGoal: Int = 150
    @AppStorage(Constants.exerciseDailyGoal)var exerciseDayGoal: Int = 30
    @AppStorage(Constants.muscleStrengtheningWeeklyGoal) var muscleWeeklyGoal: Int = 2
    
    
    // MARK: Step Count
    var currentStepCount: Int {
        steps.last?.count ?? 0
    }
    
    var stepCountPercent: Int {
        ((currentStepCount * 100) / stepGoal)
    }
    
    var averageStepCount: Int {
        steps.reduce(0) { $0 + $1.count / 7 }
    }
    
    // MARK: Resting HR
    
    var currentRestHR: Int {
        restingHR.last?.restingValue ?? 0
    }
    
    var averageRestHR: Int {
        restingHR.reduce(0) { $0 + $1.restingValue / 7}
    }
    
    var currentHRV: Int {
        hrvHR.last?.hrvValue ?? 0
    }
    
    
    // MARK: Exercise Time
    var currentExTime: Int {
        exerciseTime.last?.exerValue ?? 0
    }
    
    
    //This is for the week starting Sunday - Saturday
    var weeklyExTime: Int {
        exerciseTime.reduce(0) { $0 + $1.exerValue }
    }
    
    
    //Work around to display Exercise time for the week in a Chart. This is a work around to get the correct amount of exercise time for the past 7 days. This is not calculating the time based off the start of a brand new week like strength training from Sunday - Saturday.
    var chartAverageExTime: Int {
        exerciseTime7Days.reduce(0) {$0 + $1.exerValue / 7}
    }
    
    
    // MARK: kcals burned
    var currentKcalsBurned: Int {
        kcalBurned.last?.kcal ?? 0
    }
    
    var averageKcalsBurned: Int {
        kcalBurned.reduce(0) { $0 + $1.kcal / 7}
    }
    
    var strengthActivityWeekCount: [HKWorkout] {
        muscleStrength.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= date || $0.workoutActivityType.rawValue == 20  && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= date)
        }
    }
    
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            showAllExerciseData()
        } else {
            print("HealthKit is unavailable on this platform")
        }
    }
    
    
    //MARK: - Request User Authorization for Health Data
    func requestUserAuthorization() {
        
        let healthTypes = Set([stepType, restingHeartRateType, hrvType, exerciseTimeType, caloriesBurnedType, workoutType])
        
        guard let healthStore = self.healthStore else {
            //returning false
            return
        }
        
        
        //Passing in an empty array for toShare since we are not writing any data yet. Want to read the user's data
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in
            
            if success {
                self.showAllExerciseData()
            }
        }
    }
    
    
    func showAllExerciseData() {
        self.calculateStepCountData()
        self.calculateRestingHRData()
        self.calculateHRVData()
        self.calculateSevenDaysExerciseTime()
        self.getOneWeekExerciseChart()
        self.calculateMonthExerciseTime()
        self.calculate3MonthExerciseTime()
        self.calculateCaloriesBurned()
        self.getWorkoutData()
    }
    
    //MARK: - Calculate Step Data for One Week
    func calculateStepCountData() {
        
        //Define the predicate
        let stepCountpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        // Query for Step Count
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: stepCountpredicate,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: daily)
        
        //Setting the results handler
        query.initialResultsHandler = {
            query, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
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
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            
            
            DispatchQueue.main.async {
                
                self.steps.removeAll()
                statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let value = quantity.doubleValue(for: .count())
                        let step = Step(count: Int(value), date: date)
                        self.steps.append(step)
                    }
                }
            }
        }
        
        //Execute our query.
        self.healthStore?.execute(query)
    }
    
    // MARK: Resting HR data
    func calculateRestingHRData() {
        
        let restingHRpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        
        let restingHRquery = HKStatisticsCollectionQuery(quantityType: restingHeartRateType,
                                                         quantitySamplePredicate: restingHRpredicate,
                                                         options: .discreteAverage,
                                                         anchorDate: anchorDate,
                                                         intervalComponents: daily)
        
        
        restingHRquery.initialResultsHandler = {
            restingQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating resting HR
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
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
        
        restingHRquery.statisticsUpdateHandler = {
            restingQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            
            
            DispatchQueue.main.async {
                self.restingHR.removeAll()
                //Calculating resting HR
                statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                    if let restHRquantity = statistics.averageQuantity() {
                        let hrdate = statistics.startDate
                        
                        //HR Units
                        let hrUnit = HKUnit(from: "count/min")
                        let restHRvalue = restHRquantity.doubleValue(for: hrUnit)
                        let restHR = RestingHeartRate(restingValue: Int(restHRvalue), date: hrdate)
                        self.restingHR.append(restHR)
                    }
                }
            }
        }
        
        self.healthStore?.execute(restingHRquery)
    }
    
    
    // MARK: Heart rate variability data
    func calculateHRVData() {
        
        let hrvPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        let hrvQuery = HKStatisticsCollectionQuery(quantityType: hrvType,
                                                   quantitySamplePredicate: hrvPredicate,
                                                   options: .mostRecent,
                                                   anchorDate: anchorDate,
                                                   intervalComponents: daily)
        
        hrvQuery.initialResultsHandler = {
            hrvQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating resting HR
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                if let hrvQuantity = statistics.mostRecentQuantity() {
                    let hrvdate = statistics.startDate
                    
                    //HR Units
                    
                    let hrvValue = hrvQuantity.doubleValue(for: .secondUnit(with: .milli))
                    let hrvHR = HeartRateVariability(hrvValue: Int(hrvValue), date: hrvdate)
                    
                    DispatchQueue.main.async {
                        self.hrvHR.append(hrvHR)
                    }
                }
            }
        }
        
        hrvQuery.statisticsUpdateHandler = {
            hrvQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            
            
            
            DispatchQueue.main.async {
                self.hrvHR.removeAll()
                statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                    if let hrvQuantity = statistics.mostRecentQuantity() {
                        let hrvdate = statistics.startDate
                        
                        let hrvValue = hrvQuantity.doubleValue(for: .secondUnit(with: .milli))
                        let hrvHR = HeartRateVariability(hrvValue: Int(hrvValue), date: hrvdate)
                        self.hrvHR.append(hrvHR)
                    }
                }
            }
        }
        
        self.healthStore?.execute(hrvQuery)
    }
    
    
    //MARK: Active energy burned
    func calculateCaloriesBurned() {
        
        
        //Define the predicate
        let kCalsBurnedPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        let caloriesBurnedQuery = HKStatisticsCollectionQuery(quantityType: caloriesBurnedType,
                                                              quantitySamplePredicate: kCalsBurnedPredicate,
                                                              options: .cumulativeSum,
                                                              anchorDate: anchorDate,
                                                              intervalComponents: daily)
        
        //Setting the results handler
        caloriesBurnedQuery.initialResultsHandler = {
            calorieBurnedQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
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
        caloriesBurnedQuery.statisticsUpdateHandler = {
            calorieBurnedQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            
            DispatchQueue.main.async {
                
                self.kcalBurned.removeAll()
                statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                    if let kcalquantity = statistics.sumQuantity() {
                        let kcaldate = statistics.startDate
                        let kcalValue = kcalquantity.doubleValue(for: .kilocalorie())
                        let kcals = CaloriesBurned(kcal: Int(kcalValue), date: kcaldate)
                        
                        self.kcalBurned.append(kcals)
                    }
                }
            }
        }
        
        self.healthStore?.execute(caloriesBurnedQuery)
    }
    
    
    
    
    //MARK: One Week Exercise Time
    func calculateSevenDaysExerciseTime() {
        let predicate = HKQuery.predicateForSamples(withStart: Constants.strengthActivityWeek, end: nil, options: .strictStartDate)
        
        let exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                             quantitySamplePredicate: predicate,
                                                             options: .cumulativeSum,
                                                             anchorDate: anchorDate,
                                                             intervalComponents: daily)
        
        exerciseTimeQuery.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: Constants.strengthActivityWeek, to: self.date) { statistics, stop in
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
        
        
        exerciseTimeQuery.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            
            
            DispatchQueue.main.async {
                self.exerciseTime.removeAll()
                statisticsCollection.enumerateStatistics(from: Constants.strengthActivityWeek, to: self.date) { statistics, stop in
                    if let exerciseTimequantity = statistics.sumQuantity() {
                        let exerciseTimedate = statistics.startDate
                        
                        //Exercise Time
                        let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                        let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                        self.exerciseTime.append(exTime)
                    }
                }
            }
        }
        
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    //MARK: Work around to display Exercise time for the week in a Chart
    func getOneWeekExerciseChart() {
        
        let sevenDayExerChartpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        let exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                             quantitySamplePredicate: sevenDayExerChartpredicate,
                                                             options: .cumulativeSum,
                                                             anchorDate: anchorDate,
                                                             intervalComponents: daily)
        
        exerciseTimeQuery.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                if let exerciseTimequantity = statistics.sumQuantity() {
                    let exerciseTimedate = statistics.startDate
                    
                    //Exercise Time
                    let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                    let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                    
                    DispatchQueue.main.async {
                        self.exerciseTime7Days.append(exTime)
                    }
                }
            }
        }
        
        
        exerciseTimeQuery.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            
            
            
            DispatchQueue.main.async {
                
                self.exerciseTime7Days.removeAll()
                statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                    if let exerciseTimequantity = statistics.sumQuantity() {
                        let exerciseTimedate = statistics.startDate
                        
                        //Exercise Time
                        let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                        let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                        self.exerciseTime7Days.append(exTime)
                    }
                }
            }
        }
        
        
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    
    
    
    
    
    //MARK: One Month Exercise Time
    
    func calculateMonthExerciseTime() {
        
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let oneMonthStartDate = Calendar.current.date(byAdding: DateComponents(day: -29), to: Date())!
        
        
        let oneMonthExTimepredicate = HKQuery.predicateForSamples(withStart: oneMonthAgo, end: nil, options: .strictStartDate)
        
        let exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                             quantitySamplePredicate: oneMonthExTimepredicate,
                                                             options: .cumulativeSum,
                                                             anchorDate: anchorDate,
                                                             intervalComponents: daily)
        
        exerciseTimeQuery.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: oneMonthStartDate, to: self.date) { statistics, stop in
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
        
        exerciseTimeQuery.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            
            
            DispatchQueue.main.async {
                self.exerciseTimeMonth.removeAll()
                //Calculating exercise time
                statisticsCollection.enumerateStatistics(from: oneMonthStartDate, to: self.date) { statistics, stop in
                    if let exerciseTimequantity = statistics.sumQuantity() {
                        let exerciseTimedate = statistics.startDate
                        
                        //Exercise Time
                        let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                        let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                        
                        self.exerciseTimeMonth.append(exTime)
                    }
                }
            }
        }
        
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    
    //MARK: Three Months Exercise Time
    
    func calculate3MonthExerciseTime(){
        
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        let threeMonthStartDate = Calendar.current.date(byAdding: DateComponents(day: -89), to: Date())!
        
        
        let threeMonthExTimePredicate = HKQuery.predicateForSamples(withStart: threeMonthsAgo, end: nil, options: .strictStartDate)
        
        let exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                             quantitySamplePredicate: threeMonthExTimePredicate,
                                                             options: .cumulativeSum,
                                                             anchorDate: anchorDate,
                                                             intervalComponents: daily)
        
        exerciseTimeQuery.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: threeMonthStartDate, to: self.date) { statistics, stop in
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
        
        exerciseTimeQuery.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            //Handle errors here
            if let error = error as? HKError {
                switch (error.code) {
                case .errorHealthDataUnavailable:
                    return
                case .errorNoData:
                    return
                default:
                    return
                }
            }
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            
            
            DispatchQueue.main.async {
                self.exerciseTime3Months.removeAll()
                //Calculating exercise time
                statisticsCollection.enumerateStatistics(from: threeMonthStartDate, to: self.date) { statistics, stop in
                    if let exerciseTimequantity = statistics.sumQuantity() {
                        let exerciseTimedate = statistics.startDate
                        
                        //Exercise Time
                        let exerciseTimevalue = exerciseTimequantity.doubleValue(for: .minute())
                        let exTime = ExerciseTime(exerValue: Int(exerciseTimevalue), date: exerciseTimedate)
                        
                        self.exerciseTime3Months.append(exTime)
                    }
                }
            }
        }
        
        self.healthStore?.execute(exerciseTimeQuery)
        
    }
    
    
    // MARK: - Workout Data
    func getWorkoutData()  {
        
        let allWorkoutsPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)
        
        let allPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [allWorkoutsPredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let selectedWorkoutQuery = HKSampleQuery(
            sampleType: HKWorkoutType.workoutType(),
            predicate: allPredicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { strengthQuery, samples, error in
                
                //Handle errors here
                if let error = error as? HKError {
                    switch (error.code) {
                    case .errorHealthDataUnavailable:
                        return
                    case .errorNoData:
                        return
                    default:
                        return
                    }
                }
                
                guard let samples = samples else {
                    fatalError("An error has occurred \(error?.localizedDescription)")
                }
                
                guard let workouts = samples as? [HKWorkout] else { return }
                
                DispatchQueue.main.async {
                    for workout in workouts {
                        let yearMonth = YearAndMonth(date: workout.startDate)
                        var yearAndMonthWorkouts = self.muscleYearAndMonth[yearMonth, default: [HKWorkout]()]
                        yearAndMonthWorkouts.append(workout)
                        self.muscleYearAndMonth[yearMonth] = yearAndMonthWorkouts
                    }
                    
                    self.muscleStrength.append(contentsOf: workouts)
                }
            }
        
        self.healthStore?.execute(selectedWorkoutQuery)
    }
}
