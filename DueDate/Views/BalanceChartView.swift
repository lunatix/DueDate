//
//  BalanceChartView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftData
import SwiftUI
import Charts

struct BalanceChartView: View {
    @Query private var cards: [CreditCard]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart {
                ForEach(cards) { card in
                    BarMark(
                        x: .value("Banco", card.bankName),
                        y: .value("Balance", card.balance)
                    )
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let yValue = value.as(Double.self) {
                            Text("$\(yValue, specifier: "%.2f")")
                        }
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}
