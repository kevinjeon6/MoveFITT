//
//  CurrentSummaryCardView.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 12/30/22.
//

import SwiftUI

struct CurrentSummaryCardView: View {
    var title: String
    var description: String
    var categoryValue: String?
    
    @State private var showInfoSheet = false
    
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black.opacity(0.5), lineWidth: 3)
                .foregroundColor(.white)
                .frame(width: 200, height: 160)
            
            
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Spacer()
                    Button {
                        showInfoSheet.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .sheet(isPresented: $showInfoSheet) {
                        InfoView(description: description)
                            .presentationDetents([.medium])
                    }
                    
                }
                .frame(width: 180)
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
        CurrentSummaryCardView(title: "Health Type", description: "Description Text Here")
    }
}
