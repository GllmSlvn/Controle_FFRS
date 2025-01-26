//
//  DataTableView.swift
//  Valeurs_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-14.
//

import SwiftUI

struct DataTableView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyData.date, ascending: false)],
        animation: .default
    )
    private var dailyData: FetchedResults<DailyData> // Données Core Data
    
    @State private var selectedEntry: DailyData? = nil // Entrée sélectionnée pour modification
    @State private var showEditSheet = false           // Booléen pour afficher la feuille de modification

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Tableau des données")
                .font(.largeTitle)
                .bold()

            HStack {
                Text("Date")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("ERMP")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Circ.")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Serrures")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            List {
                ForEach(dailyData) { entry in
                    HStack {
                        // Colonne 1 : Date
                        Text(formatDate(entry.date!))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Colonne 2 : ERMP
                        Text("\(entry.ermp)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                selectEntry(entry)
                            }

                        // Colonne 3 : Circulaire
                        Text("\(entry.circulaire)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                selectEntry(entry)
                            }

                        // Colonne 4 : Serrures
                        Text("\(entry.serrures)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                selectEntry(entry)
                            }
                    }
                }
            }
        }
        .padding()
        .sheet(item: $selectedEntry) { entry in
                    EditEntryView(entry: entry, onSave: { updatedEntry in
                        saveChanges()
                    })
                }
    }
    
    private func selectEntry(_ entry: DailyData) {
        selectedEntry = entry
        showEditSheet = true
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        offsets.map { dailyData[$0] }.forEach { entry in
            PersistenceController.shared.delete(entry)
        }
    }
    
    private func saveChanges() {
        PersistenceController.shared.saveContext()
        selectedEntry = nil
        showEditSheet = false
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}


