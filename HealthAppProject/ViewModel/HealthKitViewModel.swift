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
        HKQuantityType(.heartRate),
        HKQuantityType(.appleExerciseTime),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.vo2Max),
        HKQuantityType(.respiratoryRate),
        HKQuantityType(.oxygenSaturation),
        HKWorkoutType.workoutType()
    ]
    
    // MARK: - Health Metric Data Values
    var stepData: [HealthMetric] = []
    var restingHRData: [HealthMetric] = []
    var hrvHRData: [HealthMetric] = []
    var heartRateData: [HealthMetric] = []
    var kcalBurnedData: [HealthMetric] = []
    var exerciseTime7DaysData: [HealthMetric] = []
    var exerciseTime30DaysData: [HealthMetric] = []
    var exerciseTime60DaysData: [HealthMetric] = []
    var vo2MaxData: [HealthMetric] = []
    var respiratoryRateData: [HealthMetric] = []
    var oxygenSaturationData: [HealthMetric] = []
    var muscleStrengthData: [HKWorkout] = []
    var muscleYearAndMonth = [YearAndMonth: [HKWorkout]]()
    var weekExerciseTimeData: [HealthMetric] = []
    
    // MARK: - Dates
    let calendar: Calendar
    let today: Date
    let endDate: Date
    let daily = DateComponents(day: 1)
    let hourly = DateComponents(hour: 1)

    
    // MARK: - Computed Properties
    var currentExerciseTime: Double { exerciseTime7DaysData.last?.value ?? 0.0 }
    
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
    
    // MARK: - Computed Resting HR Properties
    var currentRestHR: Double { restingHRData.last?.value ?? 0 } //USE THIS COMPUTED PROPERTY. THIS MATCHES WITH APPLE'S HEALTH VALUE
//    var mostRecentRHR: Double { restingHRData.last?.mostRecentValue ?? 0} ///NEW. KEEP IF YOU WANT TO GET THE LATEST VALUE
    
    var averageRestHR: Double { restingHRData.reduce(0) {$0 + $1.value / 7 }}
    
    // MARK: - Computed HRV Properties
    var currentHRV: Double { hrvHRData.last?.value ?? 0 }//USE THIS COMPUTED PROPERTY. THIS MATCHES APPLE'S HEALTH VALUE
//    var mostRecentHRV: Double { hrvHRData.last?.mostRecentValue ?? 0 } ///NEW
    
    var averageHRV: Double { hrvHRData.reduce(0)  { $0 + $1.value / 7 }}
    
//    var currentHR: Double { heartRateData.last?.value ?? 0 } ///Doesn't get the latest, just the last one from the element. Can DELETE. DO NOT USE. USE MOST RECENT.
    
    var mostRecentHR: Double { heartRateData.last?.mostRecentValue ?? 0 } ///Gets the latest input
   
    var heartRateRange: (min: Double, max: Double) {
        let calendar = Calendar.current
        let today = Date()
        
        // Filter for metrics from today only
        let todayMetrics = heartRateData.filter {
            calendar.isDate($0.date, inSameDayAs: today)
        }
        
        let minValues = todayMetrics.compactMap { $0.minValue ?? 0 > 0 ? $0.minValue : nil }
        let maxValues = todayMetrics.compactMap { $0.maxValue ?? 0 > 0 ? $0.maxValue : nil }
        
        return (
            min: minValues.min() ?? 0,
            max: maxValues.max() ?? 0
        )
    }
    
    var currentKcalsBurned: Double { kcalBurnedData.last?.value ?? 0 }
    
    var averageKcalBurned: Double { kcalBurnedData.reduce(0) { $0 + $1.value / 7 }}
    
    var total7DayKcalBurned: Double { kcalBurnedData.reduce(0) { $0 + $1.value }}
    
    var currentVO2max: Double { vo2MaxData.last?.value ?? 0}
    
//    var currentRespiratoryRate: Double { respiratoryRateData.last?.value ?? 0 }
    
    var mostRecentRespiratoryRate: Double { respiratoryRateData.last?.mostRecentValue ?? 0 } /// Gets the latest input. USE THIS COMPUTED PROPERTY. MATCHES APPLE HEALTH'S VALUE
    
//    var currentSpO2: Double { oxygenSaturationData.last?.value ?? 0 }
    
    var mostRecentSpO2: Double { oxygenSaturationData.last?.mostRecentValue ?? 0 } ///USE THIS COMPUTED PROPERTY. MATCHES APPLE HEALTH'S VALUE
    
    // MARK: - Initializer
    init() {
        self.calendar = Calendar.current
        self.today = calendar.startOfDay(for: .now)
        self.endDate = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        displayAll()
    }
    
    func displayAll() {
        Task {
            do {
                _ = try await getWorkoutHistory()
                _ = try await getHealthMetrics()
            } catch {
                print("Error retrieving and displaying all data: \(error)")
            }
        }
    }
    
    
    ///async let is not super scalable
    func getHealthMetrics() async throws -> [HealthMetric] {
        
        return try await withThrowingTaskGroup(of: [HealthMetric].self) { group in
            var hkData: [HealthMetric] = []
            
            group.addTask { try await self.getExerciseRelatedMetrics() }
            group.addTask { try await self.getHeartMetrics() }
            group.addTask { try await self.getRespiratoryMetrics() }
            
            
            for try await result in group {
                hkData.append(contentsOf: result)
            }
            
            return hkData
            
        }
    }
    
    // MARK: - Exercise Related Metrics Data
    func getExerciseRelatedMetrics() async throws -> [HealthMetric] {
        return try await withThrowingTaskGroup(of: [HealthMetric].self) { group in
            var exerciseMetricsData: [HealthMetric] = []
            
            group.addTask { try await self.getExerciseTime(from: -7) }
            group.addTask { try await self.getWeekTotalExerciseTime() }
            group.addTask { try await self.getStepCount(from: -7) }
            group.addTask { try await self.getKcalsBurned(from: -7) }
         
            for try await result in group {
                exerciseMetricsData.append(contentsOf: result)
            }
            
            return exerciseMetricsData
        }
    }
    
    // MARK: - All of Heart Metrics Data
    func getHeartMetrics() async throws -> [HealthMetric] {
        return try await withThrowingTaskGroup(of: [HealthMetric].self) { group in
            var heartMetricsData: [HealthMetric] = []
            
            group.addTask { try await self.getRestingHR(from: -7) }
            group.addTask { try await self.getHRV(from: -7) }
            group.addTask { try await self.getHR(from: -7) }
            
            for try await result in group {
                heartMetricsData.append(contentsOf: result)
            }
            
            return heartMetricsData
        }
    }
    
    // MARK: - All of Respiratory Metrics Data
    func getRespiratoryMetrics() async throws -> [HealthMetric] {
        return try await withThrowingTaskGroup(of: [HealthMetric].self) { group in
            var respiratoryMetricsData: [HealthMetric] = []
            
            group.addTask { try await self.getRespiratoryRateData(from: -7) }
            group.addTask { try await self.getVo2Data() }
            group.addTask { try await self.getSpO2(from: -7) }
        
            for try await result in group {
                respiratoryMetricsData.append(contentsOf: result)
            }
            
            return respiratoryMetricsData
        }
    }
    
    
    
    func getHealthDataValue(from value: Int, dataTypeIdentifier: HKQuantityType) async throws -> [HealthMetric] {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        //Create the predicate
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        //Create the query descriptor
        let samplePredicate = HKSamplePredicate.quantitySample(type: dataTypeIdentifier, predicate: queryPredicate)
        
        let sumOfQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: daily
        )

        var metrics: [HealthMetric] = []
        //If you want initial results AND live updates as your health data changes, use the results(for:)
        //You will want to loop through the returned async sequence to read the results
        for try await result in sumOfQuery.results(for: healthStore) {
            metrics = result.statisticsCollection.statistics().map{
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        }
        
        return metrics
    }
    
    
    // MARK: - Daily Step Count
    func getStepCount(from value: Int) async throws -> [HealthMetric]  {
        
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

        
        //If you want initial results AND live updates as your health data changes, use the results(for:)
        //You will want to loop through the returned async sequence to read the results
        for try await result in sumOfStepQuery.results(for: healthStore) {
            stepData = result.statisticsCollection.statistics().map{
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        }
        
        return stepData
    }
    
    
    // MARK: - Resting Heart Rate
    func getRestingHR(from value: Int) async throws -> [HealthMetric]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!

        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let restHrOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.restingHeartRate), predicate: oneWeek)
        
        let sumOfHRQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: restHrOneWeek,
            options: [.discreteAverage, .mostRecent],
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfHRQuery.results(for: healthStore) {
            restingHRData = result.statisticsCollection.statistics().map{ stats in
                guard let average = stats.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                      let mostRecentRHR = stats.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) else {
                    return HealthMetric(date: stats.startDate, value: 0)
                }
                return HealthMetric(date: stats.startDate, value: average, mostRecentValue: mostRecentRHR)
            }
        }
        
       return restingHRData
    }
    
    // MARK: - HRV
    func getHRV(from value: Int) async throws -> [HealthMetric]  {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let hrvOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.heartRateVariabilitySDNN), predicate: oneWeek)
        
        let sumOfHrvQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: hrvOneWeek,
            options: [.discreteAverage, .mostRecent],
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        
        for try await result in sumOfHrvQuery.results(for: healthStore) {
            hrvHRData = result.statisticsCollection.statistics().map{ stats in
                guard let averageHRV = stats.averageQuantity()?.doubleValue(for: .secondUnit(with: .milli)),
                      let mostRecentHRV = stats.mostRecentQuantity()?.doubleValue(for: .secondUnit(with: .milli)) else {
                    return HealthMetric(date: stats.startDate, value: averageHRV)
                }
                return HealthMetric(date: stats.startDate, value: averageHRV, mostRecentValue: mostRecentHRV)
            }
        }
        
     return hrvHRData
    }
    
    // MARK: - HR
    func getHR(from value: Int) async throws -> [HealthMetric] {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let hrOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.heartRate), predicate: oneWeek)
        
        let sumOfHrQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: hrOneWeek,
            options: [.discreteAverage, .discreteMin, .discreteMax, .mostRecent],
            anchorDate: endDate,
            intervalComponents: hourly
        )
        
   
        
        for try await result in sumOfHrQuery.results(for: healthStore) {
            heartRateData = result.statisticsCollection.statistics().map{ stats in
                guard let average = stats.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                      let minHRValue = stats.minimumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                      let maxHRValue = stats.maximumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                      let mostRecentHR = stats.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) else {
                    return HealthMetric(date: stats.startDate, value: 0)
                }
 
                return HealthMetric(date: stats.startDate, value: average, minValue: minHRValue, maxValue: maxHRValue, mostRecentValue: mostRecentHR)
            }
        }
        return heartRateData
    }
    
    
    // MARK: - Kcals Burned
    
    func getKcalsBurned(from value: Int) async throws -> [HealthMetric] {
        
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
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0)
            }
        }
        
        return kcalBurnedData
    }
    
    // MARK: - Respiratory Rate
    
    func getRespiratoryRateData(from value: Int) async throws -> [HealthMetric] {
        
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let respiratoryRateOneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.respiratoryRate), predicate: oneWeek)
        
        let sumOfRespiratoryRateQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: respiratoryRateOneWeek,
            options: [.discreteAverage, .discreteMin, .discreteMax, .mostRecent],
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfRespiratoryRateQuery.results(for: healthStore) {
            respiratoryRateData = result.statisticsCollection.statistics().map{
//                HealthMetric(date: $0.startDate, value: $0.averageQuantity()?.doubleValue(for: .count().unitDivided(by: .minute())) ?? 0)
                stats in
                    guard let average = stats.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                          let minRRValue = stats.minimumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                          let maxRRValue = stats.maximumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())),
                          let mostRecentRR = stats.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) else {
                        return HealthMetric(date: stats.startDate, value: 0)
                    }
     
                return HealthMetric(date: stats.startDate, value: average, minValue: minRRValue, maxValue: maxRRValue, mostRecentValue: mostRecentRR)
            }
        }
        
        return respiratoryRateData
    }
    
    // MARK: - VO2 Data
    
    func getVo2Data() async throws -> [HealthMetric] {
        
        ///To get the most recent VO2max data point, need distantPast because the last value recorded could have been months ago and not within a given time frame such as past 7 days. Especially if you are not walking or running outdoors.
        let startDate = Date.distantPast
        
        let vo2DateInterval = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let vo2OneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.vo2Max), predicate: vo2DateInterval)
        
        let sumofVo2Query = HKStatisticsCollectionQueryDescriptor(
            predicate: vo2OneWeek,
            options: .discreteAverage,
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumofVo2Query.results(for: healthStore) {
            vo2MaxData = result.statisticsCollection.statistics().map{ HealthMetric(date: $0.startDate, value: $0.averageQuantity()?.doubleValue(for: HKUnit(from: "ml/(kg*min)")) ?? 0)
            }
        }
        
        return vo2MaxData
    }
    
    // MARK: - Oxygen Saturation Data
    func getSpO2(from value: Int) async throws -> [HealthMetric] {
        let startDate = calendar.date(byAdding: .day, value: value, to: endDate)!
        
        let oneWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let spO2OneWeek = HKSamplePredicate.quantitySample(type: HKQuantityType(.oxygenSaturation), predicate: oneWeek)
        
        let sumOfSpO2Query = HKStatisticsCollectionQueryDescriptor(
            predicate: spO2OneWeek,
            options: [.discreteAverage, .discreteMin, .discreteMax, .mostRecent],
            anchorDate: endDate,
            intervalComponents: daily
        )
        
        for try await result in sumOfSpO2Query.results(for: healthStore) {
            oxygenSaturationData = result.statisticsCollection.statistics().map{
//                HealthMetric(date: $0.startDate, value: $0.averageQuantity()?.doubleValue(for: .percent()) ?? 0)
                stats in
                guard let average = stats.averageQuantity()?.doubleValue(for: .percent()),
                      let minSpO2Value = stats.minimumQuantity()?.doubleValue(for: .percent()),
                      let maxSpO2Value = stats.maximumQuantity()?.doubleValue(for: .percent()),
                      let mostRecentSpO2 = stats.mostRecentQuantity()?.doubleValue(for: .percent()) else {
                        return HealthMetric(date: stats.startDate, value: 0)
                    }
     
                return HealthMetric(date: stats.startDate, value: average, minValue: minSpO2Value, maxValue: maxSpO2Value, mostRecentValue: mostRecentSpO2)
            }
        }
        
        return oxygenSaturationData
    }
    
    
    // MARK: - Exercise Time
    
    func getExerciseTime(from value: Int) async throws -> [HealthMetric]  {

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
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
      return exerciseTime7DaysData
    }
    
    func getWeekTotalExerciseTime() async throws -> [HealthMetric] {
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
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
        return weekExerciseTimeData
    }
    
    
    func get30DaysExerciseTime(from value: Int) async throws -> [HealthMetric]  {
        
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
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
            }
        }
        
      return exerciseTime30DaysData
    }
    
    func get60DaysExerciseTime(from value: Int) async throws -> [HealthMetric]  {

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
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
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
