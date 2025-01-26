//
//  ContentView.swift
//  FeuilleControle_FFRS
//
//  Created by Guillaume Sylvain on 2025-01-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isConfigured") private var isConfigured: Bool = false
    @AppStorage("clientCount") private var clientCount: Int = 0
    
    /// Enlever fonction init() et resetDefaultForTesting() pour le déploiement
    /*
    init() {
            resetDefaultsForTesting()
        }
     
    private func resetDefaultsForTesting() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "isConfigured")
        defaults.removeObject(forKey: "clientCount")
        print("UserDefaults réinitialisés pour tests.")
    }
    */
    
    var body: some View {
        
        Group {
            if isConfigured {
                MainView(clientCount: clientCount)
                    .environment(\.managedObjectContext, viewContext)
            } else {
                SetupView(isConfigured: $isConfigured, clientCount: $clientCount)
            }
        }
    }
}

struct SetupView: View {
    @Binding var isConfigured: Bool
    @Binding var clientCount: Int
    
    @State private var inputClientCount: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Bienvenue !")
                .font(.largeTitle)
                .bold()
            
            Text("Avant de commencer, veuillez configurer le nombre de clients.")
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Nombre de clients", text: $inputClientCount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if let count = Int(inputClientCount), count > 0 {
                    clientCount = count
                    isConfigured = true
                }
            }) {
                Text("Valider")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(inputClientCount.isEmpty)
        }
        .padding()
    }
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
   
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyData.date, ascending: true)],
        animation: .default)
    private var dailyData: FetchedResults<DailyData>
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR") // Langue française
        return formatter.string(from: Date())
    }
    
    @State private var ermp: String = ""
    @State private var circulaire: String = ""
    @State private var serrures: String = ""
    
    let clientCount: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                
                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("ERMP (Entier)", text: $ermp)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Circulaires (Entier)", text: $circulaire)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Serrures (Entier)", text: $serrures)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        hideKeyboard()
                        saveData()
                    }) {
                        Text("Enregistrer")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: StatsView(clientCount: clientCount)) {
                        Text("Voir les statistiques")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 1.0, green: 0.0, blue: 1.0, opacity: 1.0))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: DataTableView()) {
                        Text("Voir le tableau des données")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func saveData() {
        guard let ermpValue = Int32(ermp),
              let circulaireValue = Int32(circulaire),
              let serruresValue = Int32(serrures) else {
            print("Entrées invalides")
            return
        }
    
        let todayStart = Date().startOfDay()
        
        let fetchRequest: NSFetchRequest<DailyData> = DailyData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", todayStart as NSDate, todayStart.addingTimeInterval(86400) as NSDate)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingEntry = results.first {
                existingEntry.ermp = ermpValue
                existingEntry.circulaire = circulaireValue
                existingEntry.serrures = serruresValue
                print("Mise à jour de l'entrée existante : \(existingEntry)")
            } else {
                let newData = DailyData(context: viewContext)
                newData.date = todayStart
                newData.ermp = ermpValue
                newData.circulaire = circulaireValue
                newData.serrures = serruresValue
                print("Nouvelle entrée sauvegardée : \(newData)")
            }
            
            // save in Core Data
            try viewContext.save()
        } catch {
            print("Erreur lors de la sauvegarde ou de la récupération : \(error.localizedDescription)")
        }
    
        ermp = ""
        circulaire = ""
        serrures = ""
    }

    func deleteData(offsets: IndexSet) {
        withAnimation {
            offsets.map { dailyData[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Erreur lors de la suppression : \(error.localizedDescription)")
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = DailyData(context: viewContext)
            newItem.date = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { dailyData[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
