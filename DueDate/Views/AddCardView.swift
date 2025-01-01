//
//  AddCardView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//
import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: CreditCardViewModel
    
    @State private var bankName = ""
    @State private var dayString = ""
    @State private var nextDate = ""
    
    @State private var balance = ""
    @State private var creditLimit = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Banco")) {
                    TextField("Nombre del Banco", text: $bankName)
                }
                
                Section(header: Text("Próxima Fecha (Número de Día)")) {
                    TextField("Día (1-31)", text: $dayString)
                        .keyboardType(.numberPad)
                        .onChange(of: dayString) { oldValue, newValue in
                            if let day = Int(newValue), let calculatedDate = calculateNextDate(for: day) {
                                nextDate = calculatedDate
                            } else {
                                nextDate = "Fecha inválida"
                            }
                        }
                    Text("Próxima Fecha: \(nextDate)")
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Detalles de la Tarjeta")) {
                    TextField("Deuda", text: $balance)
                        .keyboardType(.decimalPad)
                    TextField("Límite de Crédito", text: $creditLimit)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Agregar Tarjeta")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveCard()
                        dismiss()
                    }
                    .disabled(bankName.isEmpty || dayString.isEmpty || balance.isEmpty || creditLimit.isEmpty || nextDate == "Fecha inválida")
                }
            }
        }
    }
    
    // Guardar tarjeta
    private func saveCard() {
        guard let balanceValue = Double(balance),
              let creditLimitValue = Double(creditLimit),
              !bankName.isEmpty,
              let day = Int(dayString),
              let dueDate = calculateNextDate(for: day) else {
            print("Error: Datos inválidos o incompletos")
            return
        }

        viewModel.addCard(
            bankName: bankName,
            dueDate: dueDate,
            balance: balanceValue,
            creditLimit: creditLimitValue,
            context: context
        )
        
        // Generar recordatorio automáticamente
        addReminder(for: bankName, dueDate: parseDate(nextDate)!)
    }
    
    // Crear recordatorios
    private func addReminder(for bankName: String, dueDate: Date) {
        let newReminder = Reminder(
            title: "Pago a \(bankName)",
            dueDate: dueDate,
            bankName: bankName
        )
        context.insert(newReminder)
        try? context.save()
    }
    
    // Calcular próxima fecha de pago
    private func calculateNextDate(for day: Int) -> String? {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month], from: now)
        components.day = day
        
        if let date = calendar.date(from: components), date < now {
            components.month = (components.month ?? 0) + 1
        }
        
        guard let nextDate = calendar.date(from: components) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: nextDate)
    }
    
    // Convertir String a Date
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.date(from: dateString)
    }
}
