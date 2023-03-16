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
    
    // MARK: Health Type Queries
    var query: HKStatisticsCollectionQuery?
    var restingHRquery: HKStatisticsCollectionQuery?
    var hrvQuery: HKStatisticsCollectionQuery?
    var exerciseTimeQuery: HKStatisticsCollectionQuery?
    var caloriesBurnedQuery: HKStatisticsCollectionQuery?
    var selectedWorkoutQuery: HKQuery?

    
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
    
    
    

    
    // MARK: Dates for calculating data
    //Set up anchor date. Which starts on a Monday at 12:00 AM
    let anchorDate = Date.sundayAt12AM()
    
    //Set up daily to calculate health data daily
    let daily = DateComponents(day: 1)
    let date = Date()
    
    //Go Back 7 days. This is the start date
    let oneWeekAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
    let startDate = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
    
   

    
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
    
    var weeklyExTime: Int {
        exerciseTime.reduce(0) { $0 + $1.exerValue }
    }
    
    
    // MARK: kcals burned
    var currentKcalsBurned: Int {
        kcalBurned.last?.kcal ?? 0
    }
    
    var averageKcalsBurned: Int {
        kcalBurned.reduce(0) { $0 + $1.kcal / 7}
    }
    
    var currentStrengthTraining: Int {
        muscleStrength.count
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
    
        let healthTypes = Set([stepType, restingHeartRateType, hrvType, exerciseTimeType, caloriesBurnedType, workoutType])
        
        guard let healthStore = self.healthStore else {
            //returning false
            return
        }
        
        
        //Passing in an empty array for toShare since we are not writing any data yet. Want to read the user's data
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in

            if success {
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
        }
    }
    
    //MARK: - Calculate Data for One Week
    func calculateStepCountData() {
        
        //Define the predicate
        let stepCountpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
      
        
        //MARK: - Query for Step Count
        query = HKStatisticsCollectionQuery(quantityType: stepType,
                                            quantitySamplePredicate: stepCountpredicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        //Setting the results handler
        query!.initialResultsHandler = {
            query, statisticsCollection, error in
            
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
        query!.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in
            
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
        
        //Execute our query.
        guard let query = self.query else { return }
        self.healthStore?.execute(query)
    }
    
    func calculateRestingHRData() {
        
        let restingHRpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)


        restingHRquery =   HKStatisticsCollectionQuery(quantityType: restingHeartRateType,
                                                       quantitySamplePredicate: restingHRpredicate,
                                                       options: .discreteAverage,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
   
        
        restingHRquery!.initialResultsHandler = {
            restingQuery, statisticsCollection, error in
            
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
        
        restingHRquery!.statisticsUpdateHandler = {
            restingQuery, statistics, statisticsCollection, error in
            
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
        
        
        guard let restingHRquery = self.restingHRquery else { return }
        self.healthStore?.execute(restingHRquery)
    }
    
    
    
    func calculateHRVData() {

        let hrvPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        hrvQuery = HKStatisticsCollectionQuery(quantityType: hrvType,
                                               quantitySamplePredicate: hrvPredicate,
                                               options: .mostRecent,
                                               anchorDate: anchorDate,
                                               intervalComponents: daily)
        
        hrvQuery!.initialResultsHandler = {
           hrvQuery, statisticsCollection, error in
            
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
        
        hrvQuery!.statisticsUpdateHandler = {
           hrvQuery, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
       
            statisticsCollection.enumerateStatistics(from: self.startDate, to: self.date) { statistics, stop in
                if let hrvQuantity = statistics.mostRecentQuantity() {
                    let hrvdate = statistics.startDate
                    
                    let hrvValue = hrvQuantity.doubleValue(for: .secondUnit(with: .milli))
                    let hrvHR = HeartRateVariability(hrvValue: Int(hrvValue), date: hrvdate)
                    
                    DispatchQueue.main.async {
                        self.hrvHR.append(hrvHR)
                    }
                }
            }
        }
        
        
        guard let hrvQuery = self.hrvQuery else { return }
        self.healthStore?.execute(hrvQuery)
    }
    
    
    //MARK: Active energy burned
    func calculateCaloriesBurned() {

        
        //Define the predicate
        let kCalsBurnedPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)
        
        caloriesBurnedQuery = HKStatisticsCollectionQuery(quantityType: caloriesBurnedType,
                                            quantitySamplePredicate: kCalsBurnedPredicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        //Setting the results handler
      caloriesBurnedQuery!.initialResultsHandler = {
            calorieBurnedQuery, statisticsCollection, error in
            
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
        caloriesBurnedQuery!.statisticsUpdateHandler = {
            calorieBurnedQuery, statistics, statisticsCollection, error in
            
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
        
        //Execute our query.
        guard let caloriesBurnedQuery = self.caloriesBurnedQuery else { return }
        self.healthStore?.execute(caloriesBurnedQuery)
    }
    
    
    //MARK: One Week Exercise Time
    func calculateSevenDaysExerciseTime() {
        let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: date)?.start
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: predicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return}
            
            //Calculating exercise time
            statisticsCollection.enumerateStatistics(from: startDate!, to: self.date) { statistics, stop in
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
            
            statisticsCollection.enumerateStatistics(from: startDate!, to: self.date) { statistics, stop in
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
    
//MARK: Work around to display Exercise time for the week in a Chart
    func getOneWeekExerciseChart() {
        
        let sevenDayExerChartpredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: sevenDayExerChartpredicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
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
        
        
        exerciseTimeQuery!.statisticsUpdateHandler = {
            exerciseTimeQuery, statistics, statisticsCollection, error in
            
            guard let statisticsCollection = statisticsCollection else { return }
            
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
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    
    
    
    
    
    //MARK: One Month Exercise Time
    
    func calculateMonthExerciseTime() {
        
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let oneMonthStartDate = Calendar.current.date(byAdding: DateComponents(day: -29), to: Date())!
        
        
        let oneMonthExTimepredicate = HKQuery.predicateForSamples(withStart: oneMonthAgo, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: oneMonthExTimepredicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
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
       
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    }
    
    
    //MARK: Three Months Exercise Time
    
    func calculate3MonthExerciseTime(){

        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        let threeMonthStartDate = Calendar.current.date(byAdding: DateComponents(day: -89), to: Date())!
        
        
        let threeMonthExTimePredicate = HKQuery.predicateForSamples(withStart: threeMonthsAgo, end: nil, options: .strictStartDate)

        exerciseTimeQuery =  HKStatisticsCollectionQuery(quantityType: exerciseTimeType,
                                                       quantitySamplePredicate: threeMonthExTimePredicate,
                                                       options: .cumulativeSum,
                                                       anchorDate: anchorDate,
                                                       intervalComponents: daily)
    
        exerciseTimeQuery!.initialResultsHandler = {
            exerciseTimeQuery, statisticsCollection, error in
            
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
     
        
        guard let exerciseTimeQuery = self.exerciseTimeQuery else { return }
        self.healthStore?.execute(exerciseTimeQuery)
    
    }
    

    func getWorkoutData()  {
        let date = Date()
        let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: date)?.start
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)



        let strengthPredicate = HKQuery.predicateForWorkoutActivities(workoutActivityType: .traditionalStrengthTraining)
        let functionalStrengthPredicate = HKQuery.predicateForWorkoutActivities(workoutActivityType: .functionalStrengthTraining)
        
        let traditionalStrengthTrainingPredicate = HKQuery.predicateForWorkouts(activityPredicate: strengthPredicate)
        let functionalStrengthTrainingPredicate = HKQuery.predicateForWorkouts(activityPredicate: functionalStrengthPredicate)

//        let allWorkoutsPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)
        
        let tradStrengthPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [traditionalStrengthTrainingPredicate, datePredicate])
        let funcStrengthPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [functionalStrengthTrainingPredicate, datePredicate])
        let nestedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [tradStrengthPredicate, funcStrengthPredicate])

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let selectedWorkoutQuery = HKSampleQuery(
            sampleType: HKWorkoutType.workoutType(),
            predicate: nestedPredicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { strengthQuery, samples, error in

            guard let samples = samples else {
                fatalError("An error has occurred \(error?.localizedDescription)")
            }

            guard let workouts = samples as? [HKWorkout] else { return }

            DispatchQueue.main.async {
                self.muscleStrength.append(contentsOf: workouts)
                print(workouts)
            }
        }

        self.healthStore?.execute(selectedWorkoutQuery)
    }
    
}
  

