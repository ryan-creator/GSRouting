//
//  ViewRoute.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

/**
 A protocol defining a view that can be presented by the `AppNavigationRouter`.
 
 This protocol allows for the creation of presentable views with a specific body.
 
 - Important: The associated type `Body` must conform to SwiftUI's `View` protocol.
 
 Usage:
 ```swift
 struct MyViewRoute: ViewRoute {
     var body: some View {
         Text("Hello World!")
        }
     }
 }
 ```
 */
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
