//
//  StatisticsView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI
import SwiftData

struct StatisticsTabView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = CreditCardViewModel()
    @Query private var cards: [CreditCard]
    
    var totalDebt: Double {
        cards.reduce(0) { $0 + $1.balance }
    }
    
    var body: some View {
        NavigationView() {
            VStack {
                // Gráfica de balances
                BalanceChartView()
                    .padding(.bottom, 10)
                Text("Deuda Total:")
                    .font(.title2)
                    .padding(.bottom, 10)
                Text("$\(totalDebt, specifier: "%.2f")")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                    .accessibilityLabel("Deuda Total")
                    .accessibilityValue("\(totalDebt) pesos")
            }
            .navigationTitle("Balance de Tarjetas")
        }
    }
    
}

#Preview {
    StatisticsTabView()
        .modelContainer(PreviewData.container)
}
