//
//  Component.swift
//  AllerView
//
//  Created by Hyemi on 2023/07/16.
//

import SwiftUI

struct Chip: View {
    var name: String
    var height: CGFloat
    var isRemovable: Bool
    var color: Color
    var fontSize: CGFloat
    
    var body: some View {
        HStack {
            HStack {
                Text(name)
                    .padding(.vertical, 8)
                    .font(.system(size: fontSize))
                if isRemovable{
                    Image(systemName: "minus.circle.fill")
                }
            }
            .padding(.horizontal, 8)
            .background(color)
            .frame(height: height)
            .cornerRadius(35)
            
        }
    }
    
    
}

struct Previews_Chip_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Chip(name: "testddddd", height: 25, isRemovable: false, color: Color.blue, fontSize: 14)
            Chip(name: "test", height: 25, isRemovable: true, color: Color.blue, fontSize: 14)
        }
    }
}
