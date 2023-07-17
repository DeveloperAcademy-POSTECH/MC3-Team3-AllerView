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
        HStack{
            if isRemovable {
                HStack {
                    Text(name)
                        .padding(.vertical, 8)
                        .padding(.leading)
                        .font(.system(size: fontSize))
                    Image(systemName: "minus.circle.fill")
                    Spacer()
                }
                .background(color)
                .cornerRadius(35)
                .frame(height: height)
                .padding(.trailing, 1)
            } else {
                Text(name)
                    .frame(height: height)
                    .padding(.horizontal)
                    .font(.system(size: fontSize))
                    .background(color)
                    .cornerRadius(35)
                    
                    
            }
        }
    }
}
