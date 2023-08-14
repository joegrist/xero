//
//  SlideEffect.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 14/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation
import SwiftUI

/** Fancy slide-in animation for list rows */
struct SlideEffect: GeometryEffect {
    
    var y: CGFloat = 0

    var animatableData: CGFloat {
        get { return y }
        set { y = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: y * 20))
    }
}
