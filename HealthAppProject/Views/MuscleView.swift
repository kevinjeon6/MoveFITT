//
//  MuscleView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/12/23.
//

import SwiftUI

struct MuscleView: View {
    
    @ObservedObject var healthStoreVM: HealthStoreViewModel
   
    
    var body: some View {
    
        NavigationStack {
            List(healthStoreVM.muscleStrength, id: \.self) {
                workout in
                
                VStack(alignment: .leading) {
                    Text("\(workout.workoutActivityType.name)")
                    Text(String(format: "%.0f kcals", (workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0) ))
                        .font(.subheadline)
                }
            }
            .navigationTitle("Workouts")
        }
   
    }
}

struct MuscleView_Previews: PreviewProvider {
    static var previews: some View {
        MuscleView(healthStoreVM: HealthStoreViewModel())
    }
}
