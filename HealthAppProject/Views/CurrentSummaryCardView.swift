//
//  CurrentSummaryCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/30/22.
//

import SwiftUI

struct CurrentSummaryCardView: View {
    var title: String
    var categoryValue: String?
    
    @State var showInfoSheet = false
    
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: 160, height: 160)
                .shadow(color: .black.opacity(0.5), radius: 10, x: -5, y: 5)
            
            
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Spacer()
                    Button {
                        showInfoSheet.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .sheet(isPresented: $showInfoSheet) {
                        Text("Add description of health category")
                    }
                    
                }
                .frame(width: 140)
                .padding(.trailing, 10)
                .padding(.top, 20)
                
                VStack {
                    Text(title)
                        .font(.title3)
                        .opacity(0.5)
                        
                    Text(categoryValue ?? "Missing Data")
                }
                .padding(.horizontal, 20)
                
            }
            .padding(.bottom, 80)
        }
    }
}

struct CurrentSummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSummaryCardView(title: "Health Type")
    }
}
