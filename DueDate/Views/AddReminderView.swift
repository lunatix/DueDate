//
//  AddReminderView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI
import SwiftData

struct AddReminderView: View {
    @Environment(\.modelContext) private var context
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var bankName: String = ""

    var body: some View {
        VStack {
            TextField("Título", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Fecha", selection: $dueDate, displayedComponents: .date)
                .padding()
            
            TextField("Banco", text: $bankName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

            Button("Guardar") {
                let newReminder = Reminder(title: title, dueDate: dueDate, bankName: bankName)
                context.insert(newReminder)
                try? context.save()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
