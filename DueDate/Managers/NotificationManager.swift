//
//  NotificationManager.swift
//  DueDate
//
//  Created by Macbook Pro on 30/12/24.
//

import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager() // Singleton para facilitar el acceso

    private init() {}

    /// Solicita permisos de notificación al usuario
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error al solicitar permisos de notificación: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Permisos de notificación \(granted ? "otorgados" : "denegados")")
                completion(granted)
            }
        }
    }

    /// Programa una notificación para una fecha específica
    func scheduleNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Configura el disparador basado en la fecha
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Crea la solicitud de notificación
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Añade la notificación al centro de notificaciones
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error al programar la notificación: \(error.localizedDescription)")
            } else {
                print("Notificación programada exitosamente para \(date)")
            }
        }
    }

    /// Elimina todas las notificaciones pendientes
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Todas las notificaciones pendientes han sido eliminadas")
    }
}
