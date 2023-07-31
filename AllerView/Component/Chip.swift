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
    var chipColor: Color
    var fontSize: CGFloat
    var fontColor: Color
    
    var body: some View {
        HStack {
            HStack {
                Text(name)
                    .padding(.vertical, 8)
                    .font(.system(size: fontSize))
                    .foregroundColor(fontColor)
                if isRemovable{
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(chipColor)
            .frame(height: height)
            .cornerRadius(35)
            
        }
    }
    
    
}

struct Previews_Chip_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Chip(name: "testddddd", height: 25, isRemovable: false, chipColor: Color.blue, fontSize: 14, fontColor: Color.white)
            Chip(name: "test", height: 25, isRemovable: true, chipColor: Color.blue, fontSize: 14, fontColor: Color.white)
        }
    }
}
