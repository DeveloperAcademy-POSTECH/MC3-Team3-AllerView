//
//  DetailView.swift
//  AllerView
//
//  Created by 관식 on 2023/07/15.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var network = Network()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
