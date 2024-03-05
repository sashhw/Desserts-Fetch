//
//  ViewModel.swift
//  Desserts-Fetch
//
//  Created by Sasha Walkowski on 3/5/24.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var desserts: [Dessert] = []
    @Published var selectedDessert: Dessert? {
        didSet {
            fetchDetailsIfNeeded()
        }
    }
    @Published var dessertDetails: DessertDetails?
    @Published var isDetailPresented: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchDesserts() async {
        isLoading = true
        errorMessage = nil
        do {
            desserts = try await fetchDessertsData()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func fetchDetailsIfNeeded() {
        guard let id = selectedDessert?.id else { return }
        Task {
            await fetchDetails(id: id)
        }
    }

    func fetchDetails(id: String) async {
        do {
            let details = try await fetchDessertDetails(id: id)
            self.dessertDetails = details
            self.isDetailPresented = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetchDessertsData() async throws -> [Dessert] {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(DessertResponse.self, from: data)
        return decoded.desserts
    }

    private func fetchDessertDetails(id: String) async throws -> DessertDetails? {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(DetailResponse.self, from: data)
        return decoded.details.first
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
}
