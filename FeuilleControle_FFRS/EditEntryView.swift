//
//  EditEntryView.swift
//  FeuilleControle_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-18.
//

import SwiftUI

struct EditEntryView: View {
    
    @State private var ermp: Int
    @State private var circulaire: Int
    @State private var serrures: Int
    
    var entry: DailyData
    let onSave: (DailyData) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    init(entry: DailyData, onSave: @escaping (DailyData) -> Void) {
        self.entry = entry
        self.onSave = onSave
        _ermp = State(initialValue: Int(entry.ermp))
        _circulaire = State(initialValue: Int(entry.circulaire))
        _serrures = State(initialValue: Int(entry.serrures))
        
        print("Editing entry: \(entry)")
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Modifier les données")
                .font(.headline)

            HStack {
                Text("ERMP:")
                TextField("ERMP", value: $ermp, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            HStack {
                Text("Circ.:")
                TextField("Circ.", value: $circulaire, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            HStack {
                Text("Serrures:")
                TextField("Serrures", value: $serrures, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            Button("Enregistrer") {
                saveChanges()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
    
    private func saveChanges() {
        entry.ermp = Int32(ermp)
        entry.circulaire = Int32(circulaire)
        entry.serrures = Int32(serrures)
        
        onSave(entry)
        
        // Close window
        presentationMode.wrappedValue.dismiss()
    }
}

