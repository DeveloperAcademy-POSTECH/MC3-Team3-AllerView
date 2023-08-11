//
//  RoundedRectLabel.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/08/05.
//

import Foundation
import UIKit

class RoundedRectLabel: UIView {
    let label = UILabel()
    let cornerRadius: CGFloat = 5.0
    let padding: CGFloat = 5
    var text: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure the label
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        // Add constraints for the label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        // Configure the background
        backgroundColor = .orange
        layer.cornerRadius = cornerRadius
        layer.opacity = 0.6
    }
    
    func setText(text: String) {
        label.text = text
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
