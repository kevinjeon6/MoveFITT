//
//  IndicatorView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 11/21/24.
//

import SwiftUI

struct IndicatorView: View {
    @Binding var currentCard: Int?

    
    var body: some View {
        HStack {
            ForEach(0..<2) { index in
                    Circle()
                    .fill(currentCard == index ? .white : Color(.lightGray))
                    .frame(width: currentCard == index ? 12 : 8, height: 8)
                    .shadow(radius: 4)
                    .onTapGesture {
                        currentCard = index
                    }
            }
        }
        .padding(5)
        .background(.thickMaterial, in: Capsule())
    }
}
