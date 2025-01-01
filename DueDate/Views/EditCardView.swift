//
//  EditCardView.swift
//  DueDate
//
//  Created by Macbook Pro on 30/12/24.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: CreditCardViewModel
    @State var card: CreditCard

    @State private var bankName: String
    @State private var dueDate: String
    @State private var balance: String
    @State private var creditLimit: String

    init(card: CreditCard, viewModel: CreditCardViewModel) {
        self.card = card
        self.viewModel = viewModel
        _bankName = State(initialValue: card.bankName)
        _dueDate = State(initialValue: card.dueDate)
        _balance = State(initialValue: String(card.balance))
        _creditLimit = State(initialValue: String(card.creditLimit))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Banco")) {
                    TextField("Nombre del Banco", text: $bankName)
                }

                Section(header: Text("Próxima Fecha")) {
                    TextField("Día de pago", text: $dueDate)
                }

                Section(header: Text("Detalles de la Tarjeta")) {
                    TextField("Deuda", text: $balance)
                        .keyboardType(.decimalPad)
                    TextField("Límite de Crédito", text: $creditLimit)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Editar Tarjeta")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
        }
    }

    // GUardar cambios
    private func saveChanges() {
        guard let balanceValue = Double(balance),
              let creditLimitValue = Double(creditLimit) else { return }

        viewModel.updateCard(
            card: card,
            newBankName: bankName,
            newDueDate: dueDate,
            newBalance: balanceValue,
            newCreditLimit: creditLimitValue,
            context: context
        )
    }

    @Environment(\.dismiss) private var dismiss
}
