//
//  AllerViewMainApp.swift
//  AllerViewMain
//
//  Created by Hyemi on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "name == %@", "user")
    )
    var users: FetchedResults<User>

    @FetchRequest(
        entity: Keyword.entity(),
        sortDescriptors: []
    )

    var keywords: FetchedResults<Keyword>

    // MARK: - DummyData Array For UserTest

    @State var check: [Bool] = [false, false, false]

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("I'm allergy to")
                        .bold()
                        .font(.system(size: 20))
                    Spacer()
                    NavigationLink {
                        AllergySearchView(user: users.first, keywords: keywords)
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        Text("edit")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(keywords) { keyword in
                            Chip(name: keyword.name ?? "None", height: 38, isRemovable: false, chipColor: .orange, fontSize: 20, fontColor: .white)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 25)

            ZStack {
                ListView()
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 136)
                    .background(LinearGradient(
                        stops: [
                            Gradient.Stop(color: .white.opacity(0), location: 0.00),
                            Gradient.Stop(color: .white.opacity(0.8), location: 0.81),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 0.24)
                    ))
                    .offset(y: 250)
                VStack {
                    Spacer()
                    // 바코드 촬영 버튼
                    NavigationLink {
//                        CameraView(check: $check, keywords: keywords)
                    } label: {
                        Image("blackLongBarcord")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 20)
                            .background(.clear)
                    }
                }
            }
        }
        .navigationTitle("AllerView")
        .onAppear {
            if users.isEmpty {
                viewContext.createUser(name: "user")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Views

extension ContentView {
    func ListView(items: [RecentData] = RecentData.recentsDummyData()) -> some View {
        List {
            Section(header: Text("Recent").font(.system(size: 17)).fontWeight(.semibold)) {
                ForEach(items.indices, id: \.self) { index in
                    if check[index] {
                        ZStack {
                            NavigationLink {
                                ProductDetailView(recentData: items[index], keywords: keywords)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)

//                            RecentFoodView(item: items[index])
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.inset)
    }

//    func RecentFoodView(item: RecentData) -> some View {
//        HStack {
//            AsyncImage(
//                url: URL(string: item.imageUrl),
//                content: { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 80, height: 80)
//                        .clipShape(Circle())
//                        .overlay {
//                            Circle()
//                                .stroke(.blue, lineWidth: 1)
//                        }
//                },
//                placeholder: { ProgressView() }
//            )
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8)
//
//            VStack(alignment: .leading) {
//                Text(item.name)
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(item.allergen + item.ingredients, id: \.self) { allergy in
//                            if keywords.contains(where: { $0.name!.lowercased() == allergy.lowercased() }) {
//                                Chip(name: allergy.lowercased(), height: 25, isRemovable: false, color: Color.orange, fontSize: 13)
//                            }
//                        }
//
//                        ForEach(item.allergen + item.ingredients, id: \.self) { allergy in
//                            if !(keywords.contains(where: { $0.name!.lowercased() == allergy.lowercased() })) {
//                                Chip(name: allergy.lowercased(), height: 25, isRemovable: false, color: Color.blue, fontSize: 13)
//                                    .foregroundColor(.white)
//                            }
//                        }
//
//                        if item.ingredients.isEmpty {
//                            Chip(name: "none", height: 25, isRemovable: false, color: Color.gray, fontSize: 13)
//                        }
//                    }
//                }
//            }
//            .padding(.vertical)
//        }
//        .background(Rectangle().fill(Color.white))
//        .cornerRadius(10)
//        .shadow(color: .gray, radius: 3, x: 2, y: 2)
//        .listRowSeparator(.hidden)
//    }
}
