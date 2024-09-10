//
//  View+Sizing.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import SwiftUI

extension View {

    func setImageSizing() -> some View {
        frame(height: 200)
            .frame(maxWidth: .infinity)
    }
}
