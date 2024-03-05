//
//  ContentView.swift
//  Desserts-Fetch
//
//  Created by Sasha Walkowski on 3/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var isPresented = false

    var body: some View {
        VStack {
            HStack {
                Text("Desserts")
                    .font(.largeTitle)
                    .padding(.trailing, 8)
                Image(systemName: "birthday.cake")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
            List {
                ForEach(viewModel.desserts, id: \.self) { dessert in
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: dessert.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)

                        Text(dessert.name)
                            .font(.body)

                        Spacer()

                        Image(systemName: "arrow.right")
                            .frame(width: 15)
                            .aspectRatio(contentMode: .fit)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let id = dessert.id {
                            viewModel.selectedDessert = dessert
                            Task {
                                await viewModel.fetchDetails(id: id)
                            }
                            isPresented = true
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    await viewModel.fetchDesserts()
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            if let dessertDetails = viewModel.dessertDetails {
                DetailSheetView(details: dessertDetails, isPresented: $isPresented)
            }
        }
    }
}

#Preview {
    ContentView()
}
