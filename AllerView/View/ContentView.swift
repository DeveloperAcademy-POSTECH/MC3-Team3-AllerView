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

    @State private var showAllergyDetail: Bool = false
    
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
            ScannerView()
            
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
        .sheet(isPresented: $showAllergyDetail) {
            AllergyDetailView(imageUrl: "https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg?crop=1.00xw:0.753xh;0,0.153xh&resize=1200:*",
                              gptResult: GPTResult.sampleData)
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
