//
//  MuscleView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/12/23.
//

import SwiftUI

struct WorkoutHistoryView: View {
    
    @Environment(HealthKitViewModel.self) private var healthKitVM
    
   
    var body: some View {

        NavigationStack {
            List(healthKitVM.muscleYearAndMonth.keys.sorted(), id: \.self) { yearMonth in
                Section {
                    ForEach(healthKitVM.muscleYearAndMonth[yearMonth] ?? [], id: \.self) { workout in
                        HStack(spacing: 15) {

                            workout.workoutActivityType.fitnessIcon
                                .modifier(FitnessIconModifier())
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text("\(workout.workoutActivityType.name)")
                                Text(String(format: "%.0f kcals", (workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0) ))
                                Text("\(workout.startDate.formatted(.dateTime.weekday() .month().day()))")
                                Text("\(workout.startDate.formatted(.dateTime.hour().minute())) - \(workout.endDate.formatted(.dateTime.hour().minute()))")
                            }
                            .foregroundStyle(.white)
                        }
                    }
                } header: {
                    Text("\(yearMonth.monthName()) \(String(yearMonth.year))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                }

            }
            .navigationTitle("Workout History")
            .background(Color.primary)
            .scrollContentBackground(.hidden)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

struct MuscleView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
            .environment(HealthKitViewModel())
        
        HStack(spacing: 15) {
            Image(systemName: "figure.strengthtraining.traditional")
            .imageScale(.large)
            .foregroundColor(.green)
            .background(
                Circle()
                    .fill(.green.opacity(0.3))
                    .frame(width: 50, height: 50)
                )
            .frame(width: 80, height: 80)
            .border(.red)
            
            
            VStack(alignment: .leading) {
                Text("Traditional Strength Training")
                Text("256 kcals")
                Text("Mon, Jul 10")
                Text("16: 23 - 17:03")
            }
            .foregroundStyle(.white)
        }
        .background(Color.primary)
    }
}
