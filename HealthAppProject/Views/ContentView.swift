//
//  ContentView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/27/22.
//

import HealthKit
import SwiftUI

struct ContentView: View {
  
    @StateObject var healthStore = HealthStoreManager()
    
    
    
    var body: some View {
        List(healthStore.steps, id: \.id) { item in
            VStack {
                Text("\(item.count)")
                Text(item.date, style: .date)
            }
         
        }
        .onAppear {
            healthStore.requestUserAuthorization { success in
                if success {
                    healthStore.calculateDataForOneWeek()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
