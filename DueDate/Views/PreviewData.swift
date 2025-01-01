//
//  PreviewData.swift
//  DueDate
//
//  Created by Macbook Pro on 29/12/24.
//

import SwiftData


struct PreviewData {
    @MainActor
    static var container: ModelContainer {
        let container = try! ModelContainer(for: CreditCard.self)
        
        // Ejecutar la inserción de datos en el actor principal
        Task { @MainActor in
            let context = container.mainContext
            CreditCard.sampleCards().forEach { card in
                context.insert(card)
            }
        }
        return container
    }
}
