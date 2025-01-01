//
//  View+TabBar.swift
//  DueDate
//
//  Created by Macbook Pro on 30/12/24.
//
import SwiftUI

extension View {
    func tabBar(selectedTab: Binding<Tab>) -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: { selectedTab.wrappedValue = .home }) {
                    Label("Inicio", systemImage: "house")
                }
                .accentColor(selectedTab.wrappedValue == .home ? .blue : .red)
                Spacer()
                Button(action: { selectedTab.wrappedValue = .reminders }) {
                    Label("Recordatorios", systemImage: "bell")
                }
                .accentColor(selectedTab.wrappedValue == .reminders ? .blue : .red)
                Spacer()
                Button(action: { selectedTab.wrappedValue = .statistics }) {
                    Label("Estadísticas", systemImage: "chart.bar")
                }
                .accentColor(selectedTab.wrappedValue == .statistics ? .blue : .red)
                Spacer()
                Button(action: { selectedTab.wrappedValue = .settings }) {
                    Label("Configuración", systemImage: "gearshape")
                }
                .accentColor(selectedTab.wrappedValue == .settings ? .blue : .red)
                Spacer()
            }
        }
    }
}
