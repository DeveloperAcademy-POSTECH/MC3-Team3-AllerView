//
//  AllerViewMainApp.swift
//  AllerViewMain
//
//  Created by Hyemi on 2023/07/10.
//

import SwiftUI

// MARK: - Properties

struct ContentView {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("isFirst") var isFirst = true

    @StateObject private var gptModel = GPTModel()
    @State private var isSheetPresented: Bool = false

    // MARK: - Fetch CoreData

    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: []
    )
    var users: FetchedResults<User>

    @FetchRequest(
        entity: Keyword.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Keyword.createdAt, ascending: false)]
    )
    var keywords: FetchedResults<Keyword>
}

// MARK: - Views

extension ContentView: View {
    var body: some View {
        ZStack {
            if isFirst {
                AllergySearchView(user: users.first, keywords: keywords)
            } else {
                ScannerView(gptModel: gptModel, isSheetPresented: $isSheetPresented, keywords: keywords)
                    .sheet(isPresented: $isSheetPresented, onDismiss: {
                        gptModel.clear()
                    }) {
                        AllergyDetailView(gptModel: gptModel)
                    }

                VStack {
                    HStack {
                        Spacer()

                        NavigationLink {
                            AllergySearchView(user: users.first, keywords: keywords)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            MyAllergyButton()
                        }
                    }

                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 25)
            }
        }
        .onAppear {
            if users.isEmpty {
                viewContext.createUser(name: "user")
            }
        }
    }
}

// MARK: - Components

extension ContentView {
    func MyAllergyButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(.black)

            HStack(spacing: 8) {
                Image(systemName: "staroflife.fill")
                    .foregroundColor(.deepOrange)
                Text("My Allergy")
            }
            .foregroundColor(.white)
            .font(.system(size: 17, weight: .regular))
        }
        .frame(width: 143, height: 35)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
