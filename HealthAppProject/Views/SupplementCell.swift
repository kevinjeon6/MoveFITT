//
//  SupplementCell.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/26/24.
//

import SwiftUI

struct SupplementCell: View {
    
    var brandName: String
    var name: String
    var date: Date
    var category: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(brandName)
            HStack {
                Text(name)
                Text(date, format: .dateTime.month().day().year())
            }
            Text(category)
        }
    }
    
}
