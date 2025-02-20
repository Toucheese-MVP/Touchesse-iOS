//
//  HomeConceptViewModel.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/10/25.
//

import Foundation

final class StudioConceptViewModel: ObservableObject {
    // MARK: - Data
    let coceptService = DefaultConceptService(session: SessionManager.shared.baseSession)
    
    @Published var concepts: [StudioConceptEntity] = []
    
    init() {
        Task {
            await fetchConcepts()
        }
    }
    
    @MainActor
    private func fetchConcepts() async {
        do {
            concepts = try await coceptService.getStudioConcept()
            print("\(concepts)")
        } catch {
            print("fetchConcepts Error: \(error.localizedDescription)")
        }
    }
}
