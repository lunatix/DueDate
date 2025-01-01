//
//  Reminder.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import Foundation
import SwiftData

@Model
class Reminder: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var dueDate: Date
    var creditCard: CreditCard? // Relación con la tarjeta
    var bankName: String

    init(title: String, dueDate: Date, bankName: String, creditCard: CreditCard? = nil) {
        self.id = UUID()
        self.title = title
        self.dueDate = dueDate
        self.creditCard = creditCard
        self.bankName = bankName
    }
}
