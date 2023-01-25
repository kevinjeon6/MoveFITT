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
                .padding(.horizontal)
                .frame(width: 400, height: 100)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title3)
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
                .padding(.trailing, 10)
                .padding(.top, 30)
         
        
                Text(categoryValue ?? "Missing Data")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
        
                
            }
            .padding(.bottom)
            .padding(.leading)
            .frame(width: 350)
        }
    }
}

struct CurrentSummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSummaryCardView(title: "Health Type", description: "Description Text Here")
    }
}
