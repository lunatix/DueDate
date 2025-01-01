//
//  ReminderViewModel.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import Foundation
import SwiftData

class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []

    // Cargar recordatorios
    func loadReminders(context: ModelContext) {
        do {
            reminders = try context.fetch(FetchDescriptor<Reminder>())
        } catch {
            print("Error al cargar los recordatorios: \(error.localizedDescription)")
        }
    }

    // Agregar recordatorio
    func addReminder(bankName: String, date: Date, card: CreditCard, context: ModelContext) {
        let newReminder = Reminder(title: bankName, dueDate: date, bankName: bankName)
        context.insert(newReminder)

        card.reminders.append(newReminder)

        do {
            try context.save()
            print("Recordatorio creado exitosamente")
        } catch {
            print("Error al guardar el recordatorio: \(error.localizedDescription)")
        }
    }
    
    //Eliminar recordatorio
    func deleteReminder(reminder: Reminder, context: ModelContext) {
        if let card = reminder.creditCard {
            print("Tarjeta asociada antes de actualizar: \(card.bankName), Saldo: \(card.balance)")
            card.balance = 0 // Cambiar el saldo de la tarjeta a 0
        } else {
            print("Error: El recordatorio no tiene una tarjeta asociada.")
        }

        context.delete(reminder)

        do {
            try context.save()
            print("Recordatorio eliminado y cambios guardados")
        } catch {
            print("Error al guardar el contexto: \(error.localizedDescription)")
        }
    }
}
