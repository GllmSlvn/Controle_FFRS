//
//  StatsView.swift
//  Valeurs_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-14.
//

//import Foundation

import SwiftUI

struct StatsView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyData.date, ascending: true)],
        animation: .default
    )
    private var dailyData: FetchedResults<DailyData>
    
    let clientCount: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Statistiques")
                .font(.largeTitle)
            
            if dailyData.isEmpty {
                Text("Aucune donnée disponible.")
            } else {
                Text("Moyenne ERMP : \(String(format: "%.2f", average(for: \.ermp) * 5.0))")
                Text("Moyenne Lot Circ. : \(String(format: "%.2f", average(for: \.circulaire) / Double(clientCount)))")
                Text("Total Serrures : \(total(for: \.serrures))")
            }
            
            Spacer()
        }
        .padding()
    }
    
    func average(for keyPath: KeyPath<DailyData, Int32>) -> Double {
        let total = dailyData.map { Int($0[keyPath: keyPath]) }.reduce(0, +)
        return dailyData.isEmpty ? 0 : Double(total) / Double(dailyData.count)
    }
    
    func total(for keyPath: KeyPath<DailyData, Int32>) -> Int {
        return dailyData.reduce(0) { $0 + Int($1[keyPath: keyPath]) }
    }
}
