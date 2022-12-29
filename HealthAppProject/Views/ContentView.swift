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
        VStack {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Work on new HealthApp project to start career change")
        }
        .onAppear {
            healthStore.requestUserAuthorization { success in
                //
            }
        }
     
      
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
