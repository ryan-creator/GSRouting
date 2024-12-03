//
//  ViewRoute.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

@_typeEraser(AnyViewRoute)
public protocol ViewRoute: Hashable, Equatable, Identifiable where ID == String {
    /// The type of view representing the body of this ViewRoute.
    associatedtype Body: View
    
    /**
     Generates the main content body of the view to be presented in a navigation context.

     - Parameters:
        - context: The context in which this view is being presented.

     - Returns: A SwiftUI `View` representing the main content of the view.
     */
    @ViewBuilder @MainActor @preconcurrency var body: Self.Body { get }
}

public extension ViewRoute {
    
    var id: ID {
        "\(type(of: self as Any))"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
