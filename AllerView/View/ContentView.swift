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
        sortDescriptors: []
    )
    var keywords: FetchedResults<Keyword>
}

// MARK: - Views

extension ContentView: View {
    var body: some View {
        ZStack {
            ScannerView(gptModel: gptModel, isSheetPresented: $isSheetPresented, keywords: keywords)

            VStack {
                HStack {
                    Spacer()

                    NavigationLink {
                        AllergySearchView(user: users.first, keywords: keywords)
                    } label: {
                        MyAllergyButton()
                    }
                }

                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 25)
        }
        .onAppear {
            if users.isEmpty {
                viewContext.createUser(name: "user")
            }
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: {
            gptModel.clear()
        }) {
            AllergyDetailView(gptModel: gptModel, imageUrl: "https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg?crop=1.00xw:0.753xh;0,0.153xh&resize=1200:*",
                              gptResult: GPTResult.sampleData)
        }
    }
}

// MARK: - Components

extension ContentView {
    func MyAllergyButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(.black)
            HStack {
                Image(systemName: "staroflife.fill")
                Text("My Allergy")
            }
            .foregroundColor(.white)
            .font(.system(size: 17))
            .fontWeight(.regular)
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
