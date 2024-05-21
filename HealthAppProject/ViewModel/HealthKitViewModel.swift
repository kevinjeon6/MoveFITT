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
    var exerciseTimeData: [HealthMetricValue] = []
    var exerciseTimeMonth: [HealthMetricValue] = []
    var exerciseTime3Month: [HealthMetricValue] = []
    var exerciseTime7Days: [HealthMetricValue] = []
    var muscleStrengthData: [HKWorkout] = []
    var muscleYearAndMonth = [YearAndMonth: [HKWorkout]]()
    
    
    
    // MARK: - Computed Properties
    var mostRecentExerciseTime: Double { exerciseTimeData.last?.value ?? 0.0 }
    
    var weeklyExTime: Double { exerciseTimeData.reduce(0) { $0 + $1.value} }
    
    var strengthActivityWeekCount: [HKWorkout] {
        muscleStrengthData.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= Date() || $0.workoutActivityType.rawValue == 20  && $0.startDate >= Constants.strengthActivityWeek && $0.startDate <= Date())
        }
    }
    
    func updateFilteredArray(strengthStartDate: Date, strengthEndDate: Date) -> [HKWorkout] {
        muscleStrengthData.filter { ($0.workoutActivityType.rawValue == 50 && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate || $0.workoutActivityType.rawValue == 20  && $0.startDate >= strengthStartDate && $0.startDate <= strengthEndDate)
        }
    }
    
    var currentStepCount: Double { stepData.last?.value ?? 0 }
    
    var currentRestHR: Double { restingHRData.last?.value ?? 0 }
    
    var currentHRV: Double { hrvHRData.last?.value ?? 0 }
    
    var currentKcalsBurned: Double { kcalBurnedData.last?.value ?? 0 }
    
    
    
  
    func displayData() async throws  {
        await withThrowingTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {try? await self.getStepCount() }
            taskGroup.addTask {try? await self.getRestingHR() }
            taskGroup.addTask {try? await self.getHRV() }
            taskGroup.addTask {try? await self.getKcalsBurned() }
            taskGroup.addTask {try? await self.getExerciseTime() }
            taskGroup.addTask {try? await self.getWorkoutHistory() }
            
            try? await taskGroup.waitForAll()
            print(Thread.current)
        }
    }
    
    
//    @MainActor
//    func displayInfo() async throws {
//        try? await self.getStepCount()
//        try? await self.getRestingHR()
//        try? await self.getHRV()
//        try? await self.getKcalsBurned()
//        try? await self.getExerciseTime()
//        try? await self.getWorkoutHistory()
//        print(Thread.current)
//}
    
    // MARK: - Daily Step Count
    func getStepCount() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        let daily = DateComponents(day: 1)
        
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

    }
    
    
    // MARK: - Resting Heart Rate
    func getRestingHR() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        let daily = DateComponents(day: 1)
        
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
        
    }
    
    // MARK: - HRV
    func getHRV() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        let daily = DateComponents(day: 1)
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let hrvOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.heartRateVariabilitySDNN), predicate: oneWeek)
        
        let sumOfHrvQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: hrvOneWeek,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        
        for try await result in sumOfHrvQuery.results(for: healthStore) {
            hrvHRData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .secondUnit(with: .milli)) ?? 0)
            }
        }
    }
    
    
    // MARK: - Kcals Burned
    
    func getKcalsBurned() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        let daily = DateComponents(day: 1)
        
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
    }
    
    
    // MARK: - Exercise Time
    
    func getExerciseTime() async throws {
        //TODO: Figure out Date to get the sum of the start of a new week. Sunday - Saturday
        //When you get to a new day of the week (i.e. Sunday) you still get the current exercise time value
        //But the weekly total is collecting the past 7 days.
        //On a new day of the week (i.e. Sunday) the daily total and weekly total should match
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        let daily = DateComponents(day: 1)
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let exerciseTimeOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: oneWeek)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeOneWeek,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
            exerciseTimeData = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
    }
    
    

    
    func getOneMonthExerciseTime() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .month, value: -1, to: Date())!
        let ss = calendar.dateInterval(of: .day, for: startDate)?.start
        let daily = DateComponents(day: 1)
        //        static var strengthActivityWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let oneMonth = HKQuery.predicateForSamples(withStart: ss, end: Date())
  
        
        let exerciseTimeOneMonth = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: oneMonth)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeOneMonth,
            options: .cumulativeSum,
            anchorDate: today,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
            exerciseTimeMonth = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
    }
    
    func get3MonthExerciseTime() async throws {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let startDate = calendar.date(byAdding: .month, value: -3, to: Date())!
        let ss = calendar.dateInterval(of: .day, for: startDate)?.start
        let daily = DateComponents(day: 1)

        
        let threeMonth = HKQuery.predicateForSamples(withStart: ss, end: today)
        
        let exerciseTimeThreeMonths = HKSamplePredicate.quantitySample(type: HKQuantityType(.appleExerciseTime), predicate: threeMonth)
        
        let sumOfExerciseTimeQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: exerciseTimeThreeMonths,
            options: .cumulativeSum,
            anchorDate: today,
            intervalComponents: daily
        )
        
        for try await result in sumOfExerciseTimeQuery.results(for: healthStore) {
            exerciseTime3Month = result.statisticsCollection.statistics().map{
                HealthMetricValue(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
    }


    // MARK: - Getting Workout History
    
    
    func getWorkoutHistory() async throws {
        let allWorkoutsPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.workout(allWorkoutsPredicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        let results = try await descriptor.result(for: healthStore)
        
        for result in results {
            let yearMonth = YearAndMonth(date: result.startDate)
            var yearAndMonthWorkouts = self.muscleYearAndMonth[yearMonth, default: [HKWorkout]()]
            yearAndMonthWorkouts.append(result)
            self.muscleYearAndMonth[yearMonth] = yearAndMonthWorkouts
            self.muscleStrengthData.append(contentsOf: results)
        }
    }
   
    
}
