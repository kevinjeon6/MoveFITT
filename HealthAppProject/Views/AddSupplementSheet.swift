//
//  AddSupplementSheet.swift
//  MoveFITT
//
//  Created by Kevin Mattocks on 12/26/24.
//

import SwiftUI

struct AddSupplementSheet: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var brandName: String = ""
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var selectedCategory: SupplementCategory = .proteinPowderBars
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Brand Name", text: $brandName)
                TextField("Supplement Name", text: $name)
                DatePicker("Supplement Date", selection: $date, displayedComponents: .date)
                
                Section("Select a Supplement Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(SupplementCategory.allCases) {
                            category in
                            Text(category.title)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Add Supplement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        //Save item
                        let suppItem = SupplementItem(brandName: brandName, name: name, date: date, supplementCategory: selectedCategory)
                        modelContext.insert(suppItem)
                        do {
                            try modelContext.save()
                        } catch {
                            print("Failed to save supplement item: \(error)")
                        }
                        dismiss()
                    }
                }
            }

        }
    }
}

#Preview {
    AddSupplementSheet()
        .modelContainer(for: SupplementItem.self)
}
