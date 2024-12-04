//
//  EnvironmentValues.swift
//  GSRouting
//
//  Created by Ryan Cole on 2/12/2024.
//

import SwiftUI

public extension EnvironmentValues {
    /// This property stores an array of `NavigationStep` objects, representing the steps in the current navigation path.
    /// It can be used to observe and react to  the navigation state in a SwiftUI environment.
    ///
    /// - Note: The default value is an empty array.
    @Entry var navigationPath = [NavigationStep]()
}
