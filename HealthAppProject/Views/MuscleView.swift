//
//  MuscleView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/12/23.
//

import SwiftUI

struct MuscleView: View {
    
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
   
    var body: some View {

        NavigationStack {
            List(healthStoreVM.muscleStrength, id: \.self) {
                workout in

                HStack(spacing: 30) {
                    workout.workoutActivityType.fitnessIcon
                        .modifier(FitnessIconModifier())
                    VStack(alignment: .leading) {
                        Text("\(workout.workoutActivityType.name)")
                        Text(String(format: "%.0f kcals", (workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0) ))
                            .font(.subheadline)
                        Text("\(workout.startDate.formatted(.dateTime.weekday() .month().day()))")
                        Text("\(workout.startDate.formatted(.dateTime.hour().minute())) - \(workout.endDate.formatted(.dateTime.hour().minute()))")
                    }
                }
            }
            .navigationTitle("Workout History")
        }
    }
}

struct MuscleView_Previews: PreviewProvider {
    static var previews: some View {
        MuscleView()
            .environmentObject(HealthStoreViewModel())
    }
}
