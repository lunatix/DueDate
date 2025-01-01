//
//  CreditCard.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import Foundation
import SwiftData

@Model
class CreditCard: Identifiable {
    @Attribute(.unique) var id: UUID
    var bankName: String
    var dueDate: String
    var balance: Double
    var creditLimit: Double
    var reminders: [Reminder] = []

    init(bankName: String, dueDate: String, balance: Double, creditLimit: Double) {
        self.id = UUID()
        self.bankName = bankName
        self.dueDate = dueDate
        self.balance = balance
        self.creditLimit = creditLimit
    }
}
