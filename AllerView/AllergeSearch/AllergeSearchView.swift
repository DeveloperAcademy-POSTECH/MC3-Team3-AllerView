//
//  AllergeSearchView.swift
//  AllerView
//
//  Created by HyunwooPark on 2023/07/11.
//

import SwiftUI

struct AllergeSearchView: View {
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Seleted")
                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    //Allergy Tag Section
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                    Text("1222223")
                        .foregroundColor(.white)
                        .frame(height: 45)
                        .background(Color.black)
                }
                
            }
            
            SearchView()
            VStack(spacing: 20.0){
                KeywordViewModel(boldText: "Te", plainText: "st")
                KeywordViewModel(boldText: "te", plainText: "st")
                KeywordViewModel(boldText: "te", plainText: "st")
                KeywordViewModel(boldText: "te", plainText: "st")
            }
            .padding(.top)
            
            Spacer()
        }
        .padding(.horizontal, 26.0)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                NavigationBarTitle()
                    
            }
            
        }
        //        .searchable(text: $searchText)
        
    }
}
//Search Result Keywords
struct KeywordViewModel: View{
    var boldText : String
    var plainText :String
    var body: some View {
        HStack{
            Text(boldText)
                .bold()
            +
            Text(plainText)
            Spacer()
            Image(systemName: "plus.circle")
                .font(.system(size: 20))
        }
        .font(.system(size: 17))
        .padding(.horizontal,15)
//        .background(Color.blue)
        
    }
}
//Custom Naviagation Bar
struct NavigationBarTitle: View{
    var body: some View{
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
}
//Search TextField
struct SearchView: View{
    @State private var searchText = ""
    var body: some View{
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

struct AllergeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AllergeSearchView()
        }
    }
}
