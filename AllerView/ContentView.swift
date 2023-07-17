//
//  AllerViewMainApp.swift
//  AllerViewMain
//
//  Created by Hyemi on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    var chips = ChipData.chipsDummyData()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("I'm allergy to")
                            .bold()
                            .font(.system(size: 20))
                        Spacer()
                        Button("edit") {
                            //some action
                        }
                    }
                    .padding(.vertical, 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(chips) { chip in
                                Chip(name: chip.chipText, height: 38, isRemovable: false, color: .blue, fontSize: 20)
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
                        .background(LinearGradient (stops: [
                            Gradient.Stop(color: .white.opacity(0), location: 0.00),
                            Gradient.Stop(color: .white.opacity(0.8), location: 0.81),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 0.24)
                        ))
                        .offset(y: 250)
                    VStack {
                        Spacer()
                            //바코드 촬영 버튼
                            Image("blackLongBarcord")
                                .background(.clear)
                    }
                }
                
            }
            .navigationTitle("AllerView")
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
                ForEach(items) { item in
                    RecentFoodView(item: item)
                }
            }
        }
        .listStyle(.inset)
        
    }
    
    
    func RecentFoodView(item: RecentData) -> some View {
        HStack {
            Image(item.ItemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay {
                        Circle().stroke(.blue, lineWidth: 1)
                      }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)

            VStack(alignment: .leading){
                Text(item.ItemName)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(item.chips, id: \.self){chip in
                            Chip(name: chip.chipText, height: 25, isRemovable: false, color: Color.blue, fontSize: 13)
                        }
                        if item.chips.isEmpty{
                            Chip(name: "none", height: 25, isRemovable: false, color: Color.gray, fontSize: 13)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Rectangle().fill(Color.white))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 3, x: 2, y: 2)
        .listRowSeparator(.hidden)
        
    }
}
