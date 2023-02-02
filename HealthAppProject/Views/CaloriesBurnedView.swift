//
//  CaloriesBurned.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 1/30/23.
//

import HealthKit
import SwiftUI

struct CaloriesBurnedView: View {
    
    @EnvironmentObject var healthStoreVM: HealthStoreViewModel
    
    var body: some View {
        List {
            ForEach(healthStoreVM.kcalBurned.reversed(), id: \.date) {
                burn in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(burn.kcal)")
                            .font(.title2)
                            .bold()
                    }
                    Text(burn.date, style: .date)
                        .opacity(0.5)
                }
            }
        }
        .listStyle(.inset)
    }
}

struct CaloriesBurnedView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesBurnedView()
    }
}
