//
//  MainTabView.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = CreditCardViewModel()
    @State private var selectedTab: Tab = .home
    @State private var isEditing = false
    @State private var cardToEdit: CreditCard?
    @State private var showingAddCardView = false
    @Query var cards: [CreditCard]
    var isEditingBinding: Binding<Bool> {
        Binding(
            get: { cardToEdit != nil },
            set: { newValue in
                if !newValue {
                    cardToEdit = nil
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if cards.isEmpty {
                    Text("No hay tarjetas guardadas")
                    Button(action: {
                        showingAddCardView = true
                    }) {
                        Text("Agregar tarjeta")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    List(cards) {card in
                        CreditCardView(viewModel: viewModel, card: card)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteCard(card: card, context: context)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                                Button {
                                    cardToEdit = card
                                    isEditing = true
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                }
            }
            .onAppear {
                viewModel.loadCards(context: context)
            }
            .sheet(isPresented: isEditingBinding) {
                    if let cardToEdit = cardToEdit {
                        EditCardView(card: cardToEdit, viewModel: viewModel)
                    } else {
                        Text("Error: No se seleccionó ninguna tarjeta para editar.")
                    }
                }
            .sheet(isPresented: $showingAddCardView) {
                AddCardView(viewModel: viewModel)
            }
            .toolbar {
                if !viewModel.cards.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddCardView = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                        }
                    }
                }
            }
            .navigationTitle("Mis Tarjetas")
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(PreviewData.container)
}
