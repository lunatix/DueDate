//
//  CreditCardView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI

struct CreditCardView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: CreditCardViewModel
    var card: CreditCard

    var body: some View {
        VStack(alignment: .leading) {
            Text(card.bankName)
                .font(.headline)
            Text("Próximo pago: \(card.dueDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            ProgressView(value: card.balance, total: card.creditLimit)
                .accentColor(.blue)
            Text("Deuda: $\(card.balance, specifier: "%.2f") / $\(card.creditLimit, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: {
                            viewModel.payCard(card: card, context: context)
                        }) {
                            Text("PAGAR")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top)
        }
        .padding()
    }
}
