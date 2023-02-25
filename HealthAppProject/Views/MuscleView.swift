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
        List(healthStoreVM.muscleStrength, id: \.self) {
            workout in
            
            Text("\(workout.workoutActivityType.rawValue)")
            Text("\(workout.workoutActivities.description)")
          
        }
   
    }
}

struct MuscleView_Previews: PreviewProvider {
    static var previews: some View {
        MuscleView(healthStoreVM: HealthStoreViewModel())
    }
}
