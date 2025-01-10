//
//  HomeConceptViewModel.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/10/25.
//

import Foundation

final class StudioConceptViewModel: ObservableObject {
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    @Published var concepts: [StudioConceptEntity] = []
    
    init() {
        Task {
            await fetchConcepts()
        }
    }
    
    @MainActor
    private func fetchConcepts() async {
        do {
            concepts = try await networkManager.getStudioConcept()
            print("\(concepts)")
        } catch {
            print("fetchConcepts Error: \(error.localizedDescription)")
        }
    }
}
