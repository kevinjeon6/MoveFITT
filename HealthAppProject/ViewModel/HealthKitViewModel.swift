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
    
    // MARK: - Health Metric Data Values
    var stepData: [HealthMetricValue] = []
    var restingHRData: [HealthMetricValue] = []
    var hrvHRData: [HealthMetricValue] = []
    var kcalBurnedData: [HealthMetricValue] = []
    var exerciseTime7DaysData: [HealthMetricValue] = []
    var exerciseTime30DaysData: [HealthMetricValue] = []
    var exerciseTime60DaysData: [HealthMetricValue] = []
    var muscleStrengthData: [HKWorkout] = []
    var muscleYearAndMonth = [YearAndMonth: [HKWorkout]]()
    var weekExerciseTimeData: [HealthMetricValue] = []
    
    // MARK: - Dates
    let calendar: Calendar
    let today: Date
    let endDate: Date
    let daily = DateComponents(day: 1)

    
    // MARK: - Computed Properties
    var mostRecentExerciseTime: Double { exerciseTime7DaysData.last?.value ?? 0.0 }
    
    var weekTotalTime: Double { weekExerciseTimeData.reduce(0) { $0 + $1.value }}
    
    var chart7DayExTimeAvg: Double { exerciseTime7DaysData.reduce(0) { $0 + $1.value / 7} }
    
    var chart30DayExTimeAvg: Double { exerciseTime30DaysData.reduce(0) {$0 + $1.value / 30 }}
    
    var chart60DayExTimeAvg: Double { exerciseTime60DaysData.reduce(0) {$0 + $1.value / 60 }}
    
    var strengthActivityWeekCount: [HKWorkout] {
        muscleStrengthData.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= Date() || $0.workoutActivityType.rawValue == 20  && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= Date())
        }
    }
    
    func updateFilteredArray(strengthStartDate: Date, strengthEndDate: Date) -> [HKWorkout] {
        muscleStrengthData.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate || $0.workoutActivityType.rawValue == 20  && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate)
        }
    }
    
    var currentStepCount: Double { stepData.last?.value ?? 0 }
    
    var averageStepCount: Double { stepData.reduce(0) { $0 + $1.value / 7 }}
    
    var total7DayStepCount: Double { stepData.reduce(0) { $0 + $1.value }}
    
    var currentRestHR: Double { restingHRData.last?.value ?? 0 }
    
    var averageRestHR: Double { restingHRData.reduce(0) {$0 + $1.value / 7 }}
    
    var currentHRV: Double { hrvHRData.last?.value ?? 0 }
    
    var averageHRV: Double { hrvHRData.reduce(0)  { $0 + $1.value / 7 }}
    
    var currentKcalsBurned: Double { kcalBurnedData.last?.value ?? 0 }
    
    var averageKcalBurned: Double { kcalBurnedData.reduce(0) { $0 + $1.value / 7 }}
    
    var total7DayKcalBurned: Double { kcalBurnedData.reduce(0) { $0 + $1.value }}
    
  
    // MARK: - Initializer
    init() {
        self.calendar = Calendar.current
        self.today = calendar.startOfDay(for: .now)
        self.endDate = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
    }
    
  

    func displayData() async {
        async let stepCount = getStepCount(from: -7)
        async let restingHR = getRestingHR(from: -7)
        async let hrv = getHRV(from: -7)
        async let kcals = getKcalsBurned(from: -7)
        async let minutes = getExerciseTime(from: -7)
        async let thirtyMins = get30DaysExerciseTime(from: -30)
        async let sixtyMins = get60DaysExerciseTime(from: -60)
        async let workout = getWorkoutHistory()
        async let totalWeekTime = getWeekTotalExerciseTime()
        
        let data = try? await [stepCount, restingHR, hrv, minutes, kcals, workout, thirtyMins, sixtyMins, totalWeekTime]
    }
    
    
    // MARK: - Daily Step Count
    func getStepCount(from value: Int) async throws -> [HealthMetricValue]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        //Create the predicate
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        //Create the query descriptor
        let stepsInOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: oneWeek)
        
        let sumOfStepQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: stepsInOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )

        
        //If you want live updates as your health data changes, use the results(for:)
        //You will want to loop through the returned async sequence to read the results
        for try await result in sumOfStepQuery.results(for: healthStore) {
            stepData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        }
        
        return stepData
    }
    
    
    // MARK: - Resting Heart Rate
    func getRestingHR(from value: Int) async throws -> [HealthMetricValue]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!

        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let restHrOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.restingHeartRate), predicate: oneWeek)
        
        let sumOfHRQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: restHrOneWeek,
            options: .discreteAverage,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfHRQuery.results(for: healthStore) {
            restingHRData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0)
            }
        }
        
       return restingHRData
    }
    
    // MARK: - HRV
    func getHRV(from value: Int) async throws -> [HealthMetricValue]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
 
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let hrvOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.heartRateVariabilitySDNN), predicate: oneWeek)
        
        let sumOfHrvQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: hrvOneWeek,
            options: .discreteAverage,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        
        for try await result in sumOfHrvQuery.results(for: healthStore) {
            hrvHRData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.averageQuantity()?.doubleValue(for: .secondUnit(with: .milli)) ?? 0)
            }
        }
        
     return hrvHRData
    }
    
    
    // MARK: - Kcals Burned
    
    func getKcalsBurned(from value: Int) async throws -> [HealthMetricValue] {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let kCalsOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.activeEnergyBurned), predicate: oneWeek)
        
        let sumOfKcalsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: kCalsOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfKcalsQuery.results(for: healthStore) {
            kcalBurnedData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0)
            }
        }
        
        return kcalBurnedData
    }
    
    
    // MARK: - Exercise Time
    
    func getExerciseTime(from value: Int) async throws -> [HealthMetricValue]  {

        let startDate = calendar.date(byAdding: .day, value: value, to: Date())!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let exerciseTimeOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: oneWeek)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
            exerciseTime7DaysData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
      return exerciseTime7DaysData
    }
    
    func getWeekTotalExerciseTime() async throws -> [HealthMetricValue] {
        let startNewWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        
        let strengthWeek = HKQuery.predicateForSamples(withStart: startNewWeek, end: Date(), options: .strictStartDate)
        
        let strengthWeekTime = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: strengthWeek)
        
        let sumOfStrengthTime = HKStatisticsCollectionQueryDescriptor(
            predicate: strengthWeekTime,
            options: .cumulativeSum,
            anchorDate: Date(),
            intervalComponents: daily
        )
        
        for try await result in sumOfStrengthTime.results(for: healthStore) {
            weekExerciseTimeData = result.statisticsCollection.statistics().map {
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
        return weekExerciseTimeData
    }
    
    
    func get30DaysExerciseTime(from value: Int) async throws -> [HealthMetricValue]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: Date())!
      
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let exerciseTimeOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: oneWeek)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
            exerciseTime30DaysData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
      return exerciseTime30DaysData
    }
    
    func get60DaysExerciseTime(from value: Int) async throws -> [HealthMetricValue]  {

        let startDate = calendar.date(byAdding: .day, value: value, to: Date())!

        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let exerciseTimeOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: oneWeek)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
          exerciseTime60DaysData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
      return exerciseTime60DaysData
    }
    
    
    // MARK: - Getting Workout History
    
    func getWorkoutHistory() async throws -> [HKWorkout]  {
        let allWorkoutsPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(allWorkoutsPredicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        let results = try await descriptor.result(for: healthStore)
        
        var newResults: [HKWorkout] = []
        for result in results {
            
            if !self.muscleStrengthData.contains(where: { $0.uuid == result.uuid }) {
                       newResults.append(result)
                   }
            let yearMonth = YearAndMonth(date: result.startDate)
            var yearAndMonthWorkouts = self.muscleYearAndMonth[yearMonth, default: [HKWorkout]()]
            yearAndMonthWorkouts.append(result)
            self.muscleYearAndMonth[yearMonth] = yearAndMonthWorkouts
        }
        self.muscleStrengthData.append(contentsOf: newResults)
        
        return muscleStrengthData
    }
   
    
}
