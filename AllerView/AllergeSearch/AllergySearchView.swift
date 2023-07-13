//
//  AllergeSearchView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/11.
//

import SwiftUI

struct AllergySearchView {
    @State var selectedAllergies: [String] = ["Hello", "World"]
    @State var dummyData = [
        "Wheat", "Gluten", "Milk", "Lactose", "Casein", "Eggs", "Peanuts", "Tree nuts", "Almonds", "Cashews", "Walnuts", "Pecans", "Pistachios", "Hazelnuts", "Brazil nuts", "Macadamia nuts", "Pine nuts", "Soy", "Fish", "Shellfish", "Crab", "Lobster", "Shrimp", "Oysters", "Clams", "Mussels", "Scallops", "Sesame", "Mustard", "Celery", "Lupin", "Molluscs", "Sulphites", "Kiwi", "Banana", "Avocado", "Strawberry", "Citrus fruits", "Beef", "Chicken", "Pork", "Lamb", "Turkey", "Duck", "Venison", "Bison", "Rabbit", "Quinoa", "Rice", "Barley", "Oats", "Rye", "Corn", "Potatoes", "Sweet Potatoes", "Yams", "Carrots", "Onions", "Garlic", "Bell Peppers", "Tomatoes", "Eggplant", "Squash", "Zucchini", "Cucumbers", "Lettuce", "Spinach", "Broccoli", "Cauliflower", "Cabbage", "Brussels Sprouts", "Asparagus", "Peas", "Green Beans", "Mushrooms", "Olives", "Apple", "Pear", "Peach", "Plum", "Cherries", "Grapes", "Watermelon", "Cantaloupe", "Honeydew Melon", "Pineapple", "Papaya", "Mango", "Coconut", "Pomegranate", "Blueberries", "Raspberries", "Blackberries", "Cranberries", "Strawberries", "Oranges", "Lemons", "Limes", "Grapefruit", "Tangerines", "Sugar", "Salt", "Black Pepper", "Turmeric", "Cinnamon", "Basil", "Oregano", "Parsley", "Thyme", "Rosemary", "Cilantro", "Dill", "Ginger", "Paprika", "Cumin", "Nutmeg",
        "Cloves"
    ]
    @State var searchText: String = ""
    
    
}
extension AllergySearchView : View{
    var body: some View {
        VStack(alignment: .leading){
            Text("Seleted")
                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach($selectedAllergies, id: \.self){ $allergyName in
                        Text(allergyName)
                            .foregroundColor(.white)
                            .frame(height: 45)
                            .background(Color.black)
                            .onTapGesture {
                                dummyData.append(allergyName)
                                if let index = selectedAllergies.firstIndex(of: allergyName) {
                                    selectedAllergies.remove(at: index)
                                }
                            }
                        
                    }
                }
                
            }
            searchTextField
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20.0){
                    if searchText != "" {
                        ForEach(dummyData.filter {
                            $0.lowercased().hasPrefix(searchText.lowercased())},id: \.self) { data in
                                let temp = data.replacingOccurrences(of: searchText, with: "")
                                //                                searchResult(boldText: searchText, plainText: temp)
                                HStack{
                                    Text(searchText)
                                        .bold()
                                    +
                                    Text(temp)
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 20))
                                        .onTapGesture {
                                            selectedAllergies.append(data)
                                            if let index = dummyData.firstIndex(of: data) {
                                                dummyData.remove(at: index)
                                            }
                                            searchText = ""
                                        }
                                }
                                .font(.system(size: 17))
                                .padding(.horizontal,15)
                            }
                        
                    }
                    if !searchText.isEmpty{
                        HStack{
                            Text(searchText)
                                .bold()
                            Spacer()
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    selectedAllergies.append(searchText)
                                    searchText = ""
                                }
                        }
                        
                        .padding(.horizontal,15)
                    }
                    //                    .padding(.top, 10)
                }
                .padding(.top)
            }
            
            //            .frame(height: 300)
            
            Spacer()
        }
        .padding(.horizontal, 26.0)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                naviagtionBarTitle
            }
            
        }
        
    }
    var naviagtionBarTitle: some View {
        HStack{
            Text("Choose my Allergy")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .padding(0.0)
                .frame(height: 22)
            Spacer()
            Button(action: {
                //Insert Done action
            }){
                Text("Done")
            }
        }
        .padding(.horizontal, 7)
    }
    //    func searchResult(boldText: String, plainText:String) -> some View {
    //
    //
    //    }
    var searchTextField: some View{
        HStack(alignment: .center, spacing: 15) {
            TextField("Please enter your allergy", text: $searchText)
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
    
}


struct AllergySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AllergySearchView()
        }
    }
}
