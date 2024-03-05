//
//  ViewModel.swift
//  Desserts-Fetch
//
//  Created by Sasha Walkowski on 3/5/24.
//

import Foundation

@Observable
class ViewModel {
    private(set) var desserts: [Dessert] = []
    var selectedDessert: Dessert? {
        didSet {
            fetchDetailsIfNeeded()
        }
    }
    var dessertDetails: DessertDetails?
    var isDetailPresented: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    var showErrorAlert: Bool = false

    func fetchDesserts() async {
        isLoading = true
        errorMessage = nil
        do {
            var fetchedDesserts = try await fetchDessertsData()
            fetchedDesserts.sort(by: { $0.name < $1.name })
            self.desserts = fetchedDesserts

        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
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
            showErrorAlert = true
        }
    }

    private func fetchDessertsData() async throws -> [Dessert] {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(DessertResponse.self, from: data)
            return decoded.desserts
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
        return []
    }

    private func fetchDessertDetails(id: String) async throws -> DessertDetails? {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(DetailResponse.self, from: data)
            return decoded.details.first
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
        return nil
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
}
