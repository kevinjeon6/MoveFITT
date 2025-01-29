//
//  WhatsNewView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 1/29/25.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
           
            VStack {
                HStack {
                    Spacer()
                    Text("What's New")
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .tint(.primary)
                    }
                }
                .font(.title2.bold())
                .padding()
                
                GroupBox("Version 2.0.0") {
                    Divider()
                    VStack(alignment: .leading) {
                        Group {
                            Text("Added")
                                .bold()
                            Text("-A new UI look with some new features")
                            Text("-You can now add/delete your supplements that you are currently taking and select a category.")
                            Text("Added Respiratory rate, Blood oxygen, and VO2max metrics")
                            Text("Weekly dashboard that indicates the day.")
                                .padding(.bottom, 8)
                        }
                     
                        
                        Group {
                            Text("Fixes")
                                .bold()
                            Text("Fixed an issue where workouts were being duplicated in the workout history.")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    WhatsNewView()
}
