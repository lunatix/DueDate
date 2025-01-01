//
//  DueDateApp.swift
//  DueDate
//
//  Created by Macbook Pro on 28/12/24.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct DueDateApp: App {

    var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .modelContainer(for: [CreditCard.self, Reminder.self])
        }

    init() {
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error al solicitar permiso: \(error.localizedDescription)")
            }
            print("Permiso concedido: \(granted)")
        }
    }
}
