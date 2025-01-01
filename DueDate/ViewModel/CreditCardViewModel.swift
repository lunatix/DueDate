//
//  CreditCardViewModel.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import Foundation
import SwiftData

class CreditCardViewModel: ObservableObject {
    @Published var cards: [CreditCard] = []

    // Cargar tarjetas
    func loadCards(context: ModelContext) {
        do {
            cards = try context.fetch(FetchDescriptor<CreditCard>())
            print("Tarjetas cargadas: \(cards.count)")
        } catch {
            print("Error al cargar las tarjetas: \(error.localizedDescription)")
        }
    }
    
    // Agregar tarjetas
    func addCard(bankName: String, dueDate: String, balance: Double, creditLimit: Double, context: ModelContext) {
        let newCard = CreditCard(bankName: bankName, dueDate: dueDate, balance: balance, creditLimit: creditLimit)
        context.insert(newCard)

        do {
            try context.save()
            print("Tarjeta guardada exitosamente: \(newCard)")
        } catch {
            print("Error al guardar la tarjeta: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                print("Detalles del error de decodificación: \(decodingError)")
            }
        }
    }
    
    // Editar tarjetas
    func updateCard(card: CreditCard, newBankName: String, newDueDate: String, newBalance: Double, newCreditLimit: Double, context: ModelContext) {
        card.bankName = newBankName
        card.dueDate = newDueDate
        card.balance = newBalance
        card.creditLimit = newCreditLimit

        // Actualizar recordatorios relacionados
        for reminder in card.reminders {
            reminder.bankName = newBankName
            try? context.save()
        }

        do {
            try context.save()
            loadCards(context: context) // Recargar tarjetas después de editar
        } catch {
            print("Error al actualizar la tarjeta: \(error.localizedDescription)")
        }
    }
    
    // PAgar tarjeta
    func payCard(card: CreditCard, context: ModelContext) {
        // Cambiar saldo a 0
        card.balance = 0

        do {
            try context.save()
        } catch {
            print("Error al actualizar el saldo de la tarjeta: \(error.localizedDescription)")
        }
        print("Saldo de la tarjeta \(card.bankName) cambiado a 0 y recordatorios eliminados.")
        
        loadCards(context: context) // Recargar tarjetas para reflejar los cambios
    }
    
    //Eliminar tarjetas
    func deleteCard(card: CreditCard, context: ModelContext) {
        context.delete(card)

        do {
            try context.save()
            loadCards(context: context) // Recarga las tarjetas después de eliminar
        } catch {
            print("Error al eliminar la tarjeta: \(error.localizedDescription)")
        }
    }
}
