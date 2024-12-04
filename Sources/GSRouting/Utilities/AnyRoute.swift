//
//  AnyRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation
import SwiftUI

public enum ActionPriority: Int {
    case low, normal, high, critical
}

/// A type-erased ViewRoute.
public struct AnyViewRoute: ViewRoute {
        
    private let _route: any ViewRoute
    private let _priority: ActionPriority
    
    public var id: ID { _route.id }
    
    public init(erasing wrappedValue: any ViewRoute, priority: ActionPriority) {
        self._route = wrappedValue
        self._priority = priority
    }
    
    public init(erasing wrappedValue: some ViewRoute) {
        self._route = wrappedValue
        self._priority = .normal
    }
    
    public var body: some View {
        AnyView(_route.body)
    }
}

/// A type-erased TabRoute.
public struct AnyTabRoute: TabRoute {
    public typealias TabLabel = AnyView
    public typealias TabContent = AnyView
        
    private let _route: any TabRoute
    
    public var id: ID { _route.id }
    
    public init(erasing wrappedValue: any TabRoute) {
        self._route = wrappedValue
    }
    
    public init(erasing wrappedValue: some TabRoute) {
        self._route = wrappedValue
    }
    
    public func makeLabel(context: Context) -> Self.TabLabel {
        AnyView(_route.makeLabel(context: context))
    }
    
    public func makeContent(context: Context) -> Self.TabContent {
        AnyView(_route.makeContent(context: context))
    }
}
