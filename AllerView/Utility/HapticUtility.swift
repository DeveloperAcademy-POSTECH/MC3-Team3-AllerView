//
//  HapticUtility.swift
//  AllerView
//
//  Created by Eojin Choi on 2023/08/16.
//

import SwiftUI
import CoreHaptics

class HapticUtility {
    static let instance = HapticUtility()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
