//
//  AllergeSearchView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/11.
//

import SwiftUI

struct AllergySearchView {
    @Environment(\.managedObjectContext) var viewContext
    // MARK: - Allergy dummyData
    
    var dummyData = [
        "wheat", "gluten", "milk", "lactose", "casein", "eggs", "peanuts", "tree nuts", "almonds", "cashews", "walnuts", "pecans", "pistachios", "hazelnuts", "brazil nuts", "macadamia nuts", "pine nuts", "soy", "fish", "shellfish", "crab", "lobster", "shrimp", "oysters", "clams", "mussels", "scallops", "sesame", "mustard", "celery", "lupin", "molluscs", "sulphites", "kiwi", "banana", "avocado", "strawberry", "citrus fruits", "beef", "chicken", "pork", "lamb", "turkey", "duck", "venison", "bison", "rabbit", "quinoa", "rice", "barley", "oats", "rye", "corn", "potatoes", "sweet potatoes", "yams", "carrots", "onions", "garlic", "bell peppers", "tomatoes", "eggplant", "squash", "zucchini", "cucumbers", "lettuce", "spinach", "broccoli", "cauliflower", "cabbage", "brussels sprouts", "asparagus", "peas", "green beans", "mushrooms", "olives", "apple", "pear", "peach", "plum", "cherries", "grapes", "watermelon", "cantaloupe", "honeydew melon", "pineapple", "papaya", "mango", "coconut", "pomegranate", "blueberries", "raspberries", "blackberries", "cranberries", "strawberries", "oranges", "lemons", "limes", "grapefruit", "tangerines", "sugar", "salt", "black pepper", "turmeric", "cinnamon", "basil", "oregano", "parsley", "thyme", "rosemary", "cilantro", "dill", "ginger", "paprika", "cumin", "nutmeg", "cloves"
    ]
    // MARK: - Fetch
    
    let user: User?
    
    let keywords: FetchedResults<Keyword>
    
    @State var searchText: String = ""
}

extension AllergySearchView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Seleted")
                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                .padding(.top)
            
            // MARK: - selected keywords
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(keywords) { keyword in
                        Chip(name: keyword.name ?? "Unknown", height: 25, isRemovable: true, color: Color.blue, fontSize: 13)
//                        Text(keyword.name ?? "Unknown")
//                            .foregroundColor(.white)
//                            .frame(height: 45)
//                            .background(Color.black)
                            .onTapGesture {
                                keyword.delete()
                            }
                    }
                    
                }
            }
            // MARK: - search Field
            searchTextField
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20.0) {
                    if searchText != "" {
                        ForEach(getFilteredData(), id: \.self) { data in
                            let temp = data.replacingOccurrences(of: searchText, with: "")
                            HStack {
                                Text(searchText)
                                    .bold()
                                +
                                Text(temp)
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 20))
                                    .onTapGesture {
                                        addKeyword(keywordName: data)
                                    }
                            }
                            .font(.system(size: 17))
                            .padding(.horizontal, 15)
                        }
                        
                    }
                    if !searchText.isEmpty {
                        HStack {
                            Text(searchText)
                                .bold()
                            Spacer()
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    addKeyword(keywordName: searchText)
                                    searchText = ""
                                }
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.top)
            }
            Spacer()
        }
        .padding(.horizontal, 26.0)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                naviagtionBarTitle
            }
            
        }
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
    
    var searchTextField: some View {
        HStack(alignment: .center, spacing: 15) {
            TextField("Please enter your allergy", text: $searchText)
                .autocapitalization(.none)
                .padding(.vertical, 3)
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(Font.custom("SF Pro", size: 24))
        }
        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
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
