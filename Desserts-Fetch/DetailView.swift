//
//  SwiftUIView.swift
//  Desserts-Fetch
//
//  Created by Sasha Walkowski on 3/5/24.
//

import SwiftUI

struct DetailSheetView: View {
    let details: DessertDetails
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: details.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())

                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)

                    Button { isPresented = false } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 14, height: 14)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }

                Text(details.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 30)
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Ingredients")
                        .font(.headline)
                        .bold()

                    Text(details.joinedIngredientsMeasurements)
                        .font(.body)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.secondary)
                        .opacity(0.1)
                }
                .padding(.horizontal, 60)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Instructions")
                        .font(.headline)

                    Text(details.instructionsWithBreak)
                        .font(.subheadline)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.secondary)
                        .opacity(0.1)
                }
                .padding(15)
            }
        }
    }
}
