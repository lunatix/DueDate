//
//  RemindersTabView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI
import SwiftData


struct RemindersTabView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\Reminder.dueDate, order: .forward)]) private var reminders: [Reminder]
    @State private var showingAddReminder = false
    @StateObject private var viewModel = ReminderViewModel()
    @State private var cards: [CreditCard] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if reminders.isEmpty {
                    Text("No hay recordatorios")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(reminders) { reminder in
                        ReminderListView(viewModel: viewModel, reminder: reminder)
                    }
                    Text("Desliza a la izquiera para eliminar recordatorio y marcar la tarjeta como Pagada")
                        .font(.caption)
                }
            }
            .navigationTitle("Recordatorios")
            .onAppear {
                loadCards() // Cargar las tarjetas al aparecer
                viewModel.loadReminders(context: context)
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView()
            }
        }
    }
    
    func loadCards() {
        do {
            cards = try context.fetch(FetchDescriptor<CreditCard>())
        } catch {
            print("Error al cargar las tarjetas: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RemindersTabView()
        .modelContainer(PreviewData.container)
}

