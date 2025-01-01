//
//  SettingsTabView.swift
//  DueDate
//
//  Created by Macbook Pro on 30/12/24.
//

import SwiftUI
import UserNotifications
import SwiftData

@available(iOS 18.0, *)
struct SettingsTabView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("notificationTime") private var notificationTime: Date = Calendar.current.startOfDay(for: Date()).addingTimeInterval(9 * 3600) // 9:00 AM

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notificaciones")) {
                    Toggle("Permitir Notificaciones", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            if newValue {
                                requestNotificationPermissions()
                            } else {
                                disableNotifications()
                            }
                        }
                    
                    DatePicker("Hora de Notificación", selection: $notificationTime, displayedComponents: .hourAndMinute)
                        .disabled(!notificationsEnabled)
                }
                
                Section(header: Text("Datos de la App")) {
                    Button("Borrar Todos los Datos", role: .destructive) {
                        clearAppData()
                    }
                }
            }
            .navigationTitle("Configuración")
        }
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func clearAppData() {
        do {
            let cards = try context.fetch(FetchDescriptor<CreditCard>())
            for card in cards {
                context.delete(card)
            }

            let reminders = try context.fetch(FetchDescriptor<Reminder>())
            for reminder in reminders {
                context.delete(reminder)
            }

            try context.save()
        } catch {
            print("Error al borrar los datos: \(error.localizedDescription)")
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        SettingsTabView()
    } else {
        // Fallback on earlier versions
    }
}
