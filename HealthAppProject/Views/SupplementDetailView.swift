//
//  SupplementDetailView.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/25/24.
//

import SwiftData
import SwiftUI

struct SupplementDetailView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var supplement: SupplementItem
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Brand Name", text: $supplement.brandName)
                    .autocorrectionDisabled()
                TextField("Supplement Name", text: $supplement.name)
                    .autocorrectionDisabled()
                DatePicker("Supplement Date", selection: $supplement.date, displayedComponents: .date)
                
                Section {
                    Button {
                        dismiss()
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Supplement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        modelContext.delete(supplement)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SupplementDetailView(supplement: .init(brandName: "Ryse", name: "Loaded-Pre", date: Date()))
}
