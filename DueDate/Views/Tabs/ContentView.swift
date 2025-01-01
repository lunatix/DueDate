//
//  ContentView.swift
//  DueDate
//
//  Created by Macbook Pro on 28/12/24.
//

import Foundation
import SwiftUI
import SwiftData

import SwiftUI

enum Tab {
    case home
    case reminders
    case statistics
    case settings
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack {
            Group {
                switch selectedTab {
                case .home:
                    MainTabView()
                case .reminders:
                    RemindersTabView()
                case .statistics:
                    StatisticsTabView()
                case .settings:
                    if #available(iOS 18, *) {
                        SettingsTabView()
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
        }
        .tabBar(selectedTab: $selectedTab)
    }
}


extension CreditCard {
    static func sampleCards() -> [CreditCard] {
        return [
            CreditCard(bankName: "Banco Uno", dueDate: "10/01/2024", balance: 5000, creditLimit: 15000),
            CreditCard(bankName: "Banco Dos", dueDate: "15/01/2024", balance: 2500, creditLimit: 10000)
        ]
    }
}

func calculateNextDate(for day: Int) -> String? {
    guard day >= 1 && day <= 31 else { return nil } // Validar rango de días
    
    let today = Date()
    var components = Calendar.current.dateComponents([.year, .month, .day], from: today)
    
    // Ajustar el día al ingresado por el usuario
    components.day = day
    
    // Intentar obtener la fecha en el mes actual
    if let dateThisMonth = Calendar.current.date(from: components),
       dateThisMonth >= today {
        return formatDate(dateThisMonth)
    }
    
    // Si no es válido, calcular en el siguiente mes
    components.month = (components.month ?? 1) + 1
    if let dateNextMonth = Calendar.current.date(from: components) {
        return formatDate(dateNextMonth)
    }
    
    return nil
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

#Preview {
    ContentView()
}
