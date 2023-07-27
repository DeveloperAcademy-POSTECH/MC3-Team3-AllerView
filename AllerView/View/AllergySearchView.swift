//
//  AllergeSearchView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/11.
//

import SwiftUI

struct AllergySearchView {
    @FocusState var keyboardFocused: Bool
    @Environment(\.managedObjectContext) var viewContext
    // MARK: - Allergy dummyData
    
    var dummyData = [
        "wheat", "gluten", "milk", "lactose", "casein", "eggs", "peanuts", "tree nuts", "almonds", "cashews", "walnuts", "pecans", "pistachios", "hazelnuts", "brazil nuts", "macadamia nuts", "pine nuts", "soy", "fish", "shellfish", "crab", "lobster", "shrimp", "oysters", "clams", "mussels", "scallops", "sesame", "mustard", "celery", "lupin", "molluscs", "sulphites", "kiwi", "banana", "avocado", "strawberry", "citrus fruits", "beef", "chicken", "pork", "lamb", "turkey", "duck", "venison", "bison", "rabbit", "quinoa", "rice", "barley", "oats", "rye", "corn", "potatoes", "sweet potatoes", "yams", "carrots", "onions", "garlic", "bell peppers", "tomatoes", "eggplant", "squash", "zucchini", "cucumbers", "lettuce", "spinach", "broccoli", "cauliflower", "cabbage", "brussels sprouts", "asparagus", "peas", "green beans", "mushrooms", "olives", "apple", "pear", "peach", "plum", "cherries", "grapes", "watermelon", "cantaloupe", "honeydew melon", "pineapple", "papaya", "mango", "coconut", "pomegranate", "blueberries", "raspberries", "blackberries", "cranberries", "strawberries", "oranges", "lemons", "limes", "grapefruit", "tangerines", "sugar", "salt", "black pepper", "turmeric", "cinnamon", "basil", "oregano", "parsley", "thyme", "rosemary", "cilantro", "dill", "ginger", "paprika", "cumin", "nutmeg", "cloves"
    ]
    // MARK: - Fetch
    
    let user: User?
    
    let keywords: FetchedResults<Keyword>
    
    @State var searchText: String = ""
    @State private var showImage = false
}

extension AllergySearchView: View {
    var body: some View {
        VStack {
            // MARK: - selected keywords
            
            if !keywords.isEmpty {
                VStack(alignment: .leading) {
                    Text("Seleted")
                        .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.39))
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(keywords) { keyword in
                                Chip(name: keyword.name ?? "Unknown", height: 35, isRemovable: true, chipColor: Color.deepOrange, fontSize: 20, fontColor: Color.white)
                                    .onTapGesture {
                                        keyword.delete()
                                    }
                            }
                        }
                    }
                    
                }
            }
            
            // MARK: - reading glasses and guiding text
            
            ZStack {
                if searchText.isEmpty {
                    VStack{
                        Image(systemName: "plus.magnifyingglass")
                            .resizable()
                            .frame(width: 52, height: 52)
                        Text("Add your allergy to expeience!")
                            .font(.system(size: 20))
                    }
                    .foregroundColor(Color.deepOrange)
                }
                
                // MARK: - search results Field
                
                VStack(spacing: 15) {
//                    ZStack {
                        ScrollView {
                            VStack {
                                if !searchText.isEmpty {
                                    HStack {
                                        Text(searchText)
                                            .bold()
                                            .foregroundColor(Color.deepOrange)
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.deepOrange)
                                        
                                    }
                                    .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                                                        .padding(.top, -7)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        addKeyword(keywordName: searchText)
                                        searchText = ""
                                    }
                                }
                                if searchText != "" {
                                    ForEach(getFilteredData().reversed(), id: \.self) { data in
                                        let temp = data.replacingOccurrences(of: searchText, with: "")
                                        
                                        VStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 340, height: 1)
                                                .background(Color.lightGray2)
                                            HStack {
                                                Text(searchText)
                                                    .bold()
                                                +
                                                Text(temp)
                                                Spacer()
                                                Image(systemName: "plus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color.deepOrange)
                                            }
                                            .padding(.bottom, 4.8)
                                            .padding(.top, 3.5)
                                            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                addKeyword(keywordName: data)
                                            }
                                            .font(.system(size: 17))
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.top)
                        }
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        // MARK: - arrow for scrolling animation
                        
//                        if !searchText.isEmpty && getFilteredData().count > 5 {
//                            Image(systemName: "hand.point.up")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 80, height: 80)
//                                .opacity(showImage ? 0.6 : 0.0)
//                                .animation(.easeInOut(duration: 0.3))
//                                .offset(y: showImage ? +5 : -5)
//                                .onAppear {
//                                    showImage = true
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                        showImage = false
//                                    }
//                                }
//                        }
//                    }
                    
                    searchTextField
                        .padding(.bottom, 10)
                }
            }
            
        }
        .padding(.horizontal, 26.0)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                naviagtionBarTitle
            }
        }
        .navigationBarItems(trailing: Button("Done") {
            //action
        })
    }
    // MARK: - navigation bar custom
    
    var naviagtionBarTitle: some View {
        HStack {
            Text("Choose my Allergy")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(0.0)
                .frame(height: 22)
        }
        .padding(.horizontal, 7)
    }
    // MARK: - searchTextField custom
    
    var searchTextField: some View {
        HStack(alignment: .center, spacing: 15) {
            TextField("Please enter your allergy", text: $searchText)
                .autocapitalization(.none)
                .padding(.vertical, 3)
                .focused($keyboardFocused)
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(Font.custom("SF Pro", size: 24))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                keyboardFocused = true}
        }
        .foregroundColor(Color.deepGray2)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    
    // MARK: - keyword add function
    func addKeyword(keywordName: String) {
        let isDuplicate = keywords.contains { keyword in
            keyword.name == keywordName.lowercased()
        }
        
        if !isDuplicate {
            viewContext.createKeyword(
                name: keywordName.lowercased(),
                user: user
            )
        }
    }
    
    // MARK: - ArrayFilter for Search
    func getFilteredData() -> [String] {
        return dummyData.filter { data in
            let isUserKeyword = keywords.contains { keyword in
                keyword.name == data
            }
            let isMatchingPrefix = data.lowercased().hasPrefix(searchText.lowercased())
            
            return !isUserKeyword && isMatchingPrefix
        }
        
    }
}
//struct AllergySearchView_Previews: PreviewProvider {
//    static var previews: some View {
//
//
////        AllergySearchView(user: user, keywords: keywords)
////            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

