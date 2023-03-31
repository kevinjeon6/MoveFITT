//
//  StrengthActivityWeekView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 3/19/23.
//

import SwiftUI

struct StrengthActivityWeekView: View {
    
    @ObservedObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(Constants.currentWeekDatesString)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            if healthStoreVM.strengthActivityWeekCount.count == 0 {
                    Text("You have completed 0 muscle strengthening workouts this week")
                        .font(.title)
            } else {
                ForEach(healthStoreVM.updateFilteredArray(strengthStartDate:  Calendar.current.dateInterval(of: .weekOfYear, for: Date())!.start, strengthEndDate: Date()), id: \.self) { strengthWorkout in
                    
                    HStack {
                        strengthWorkout.workoutActivityType.fitnessIcon
                            .modifier(FitnessIconModifier())
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("\(strengthWorkout.workoutActivityType.name)")
                            Text("\(strengthWorkout.startDate.formatted(.dateTime.weekday()))")
                                
                        }
                        .font(.headline)
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cardBackground()
    }
}

struct StrengthActivityWeekView_Previews: PreviewProvider {
    static var previews: some View {
        StrengthActivityWeekView(healthStoreVM: HealthStoreViewModel())
    }
}
