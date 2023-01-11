//
//  CurrentSummaryCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/30/22.
//

import SwiftUI

struct CurrentSummaryCardView: View {
    
    
    var body: some View {
       
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .aspectRatio(CGSize(width: 300, height: 300), contentMode: .fit)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: -5, y: 5)
                    .padding(.horizontal)
                   
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    HStack {
                        Text("Current Stats")
                            .font(.title2)
                            .opacity(0.5)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 25) {
                  
                        HStack {
                            
                            VStack {
                                Text("Energy Burned")
                                    .font(.headline)
                                Text("300 kcals")
                            }
                            Spacer()
                            VStack {
                                Text("Resting HR")
                                    .font(.headline)
                                Text("300 kcals")
                            }

                        }
               
                        HStack {
                            VStack {
                                Text("Respiratory Rate")
                                    .font(.headline)
                                Text("15 breaths/min")
                            }
                            Spacer()
                            VStack {
                                Text("Blood Oxygen")
                                    .font(.headline)
                                Text("100%")
                            }
                        }
                      
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        
        }
}

struct CurrentSummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSummaryCardView()
    }
}
