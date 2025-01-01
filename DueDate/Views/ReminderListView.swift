//
//  ReminderListView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI
import SwiftData
import EventKit

struct ReminderListView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: ReminderViewModel
    var reminder: Reminder
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(reminder.title)
                .font(.headline)
            Text("\(reminder.dueDate, formatter: dateFormatter)")
                .font(.largeTitle)
                .bold()
        }
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteReminder(reminder: reminder, context: context)
            } label: {
                Label("Pagado", systemImage: "creditcard")
            }
            .tint(Color.green)
        }
    }
//
//    @StateObject private var viewModel = ReminderViewModel()
//    private var reminders: [Reminder]
//    let reminders: [Reminder]
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(reminder.bankName)
//                        .font(.title2)
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text("Próximo pago:")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        Text("\(reminder.dueDate, formatter: dateFormatter)")
//                            .bold()
//                            .font(.largeTitle)
//                    }
//                    .swipeActions {
//                        Button(role: .destructive) {
//                            viewModel.deleteReminder(reminder: reminder, context: context)
//                        } label: {
//                            Label("Eliminar", systemImage: "trash")
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .shadow(radius: 5)
//                }
//            }
//            .onAppear {
//                checkPendingNotifications()
//            }
//        }
//        .padding()
//    }
    
    private func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Notificación pendiente: \(request.identifier)")
            }
        }
    }
    
    func requestCalendarPermission(completion: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestFullAccessToEvents() { granted, error in
            if let error = error {
                print("Error al solicitar permiso: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }
    
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, notes: String?) {
        let eventStore = EKEventStore()
        
        // Solicita permiso antes de agregar el evento
        requestCalendarPermission { granted in
            guard granted else {
                print("Permiso denegado para acceder al calendario")
                return
            }
            
            // Crear el evento
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = notes
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            // Guardar el evento en el calendario
            do {
                try eventStore.save(event, span: .thisEvent)
                print("Evento agregado al calendario")
            } catch {
                print("Error al guardar el evento: \(error.localizedDescription)")
            }
        }
        
        func addReminderToCalendar(for reminder: Reminder) {
            addEventToCalendar(
                title: reminder.title,
                startDate: reminder.dueDate,
                endDate: reminder.dueDate.addingTimeInterval(3600), // Duración de 1 hora
                notes: "Recordatorio relacionado con el banco \(reminder.bankName)"
            )
        }
        
        func addReminder(for bankName: String, dueDate: Date) {
            let newReminder = Reminder(
                title: "Pago a \(bankName)",
                dueDate: dueDate,
                bankName: bankName
            )
            context.insert(newReminder)
            
            // Agregar al calendario
            addReminderToCalendar(for: newReminder)
            
            // Guardar el contexto
            try? context.save()
        }
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

//#Preview {
//    Reminder(reminder: .init(title: "Reminder", bankName: "Bank", dueDate: Date(), isCompleted: false))
//}
