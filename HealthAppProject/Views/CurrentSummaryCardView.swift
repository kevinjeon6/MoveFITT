//
//  CurrentSummaryCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/30/22.
//

import SwiftUI

struct CurrentSummaryCardView: View {
    var healthCategory1: String?
    var categoryValue1: String?
    
    var healthCategory2: String?
    var categoryValue2: String?
    
    var healthCategory3: String?
    var categoryValue3: String?
    
    var healthCategory4: String?
    var categoryValue4: String?
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .aspectRatio(CGSize(width: 300, height: 300), contentMode: .fit)
                .shadow(color: .black.opacity(0.5), radius: 10, x: -5, y: 5)
                .padding(.horizontal, 5)
            
            
            VStack(alignment: .leading, spacing: 10) {
                
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
                            Text(healthCategory1 ?? "N/A")
                                .font(.headline)
                            Text(categoryValue1 ?? "Missing data")
                        }
                        Spacer()
                        VStack {
                            Text(healthCategory2 ?? "N/A")
                                .font(.headline)
                            Text(categoryValue2 ?? "Missing data")
                        }
                        
                    }
                    
                    HStack {
                        VStack {
                            Text(healthCategory3 ?? "N/A")
                                .font(.headline)
                            Text(categoryValue3 ?? "Missing data")
                        }
                        Spacer()
                        VStack {
                            Text(healthCategory4 ?? "N/A")
                                .font(.headline)
                            Text(categoryValue4 ?? "Missing data")
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
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
