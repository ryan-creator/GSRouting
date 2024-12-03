//
//  AppNavigationRouter.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

@MainActor
public final class AppNavigationRouter: ObservableObject {
    private var callbacks: Callbacks?
    
    internal func initialize(
        push: @escaping (AnyViewRoute) -> Void,
        pop: @escaping () -> Void,
        popToRoot: @escaping () -> Void,
        presentSheet: @escaping (AnyViewRoute) -> Void,
        presentCover: @escaping (AnyViewRoute) -> Void,
        switchToTab: @escaping (_ id: String) -> Void,
        presentPath: @escaping (_ path: [AnyViewRoute]) -> Void,
        closeSheet: @escaping () -> Void,
        closeFullScreenCover: @escaping () -> Void
    ) {
        self.callbacks = Callbacks(
            push: push,
            pop: pop,
            popToRoot: popToRoot,
            presentSheet: presentSheet,
            presentCover: presentCover,
            switchToTab: switchToTab,
            presentPath: presentPath,
            closeSheet: closeSheet,
            closeFullScreenCover: closeFullScreenCover
        )
    }
    
    public func pop() {
        callbacks?.pop()
    }
    
    public func popToRoot() {
        callbacks?.popToRoot()
    }
    
    public func switchTab(id: String) {
        callbacks?.switchToTab(id)
    }
    
    public func push(_ view: some ViewRoute, priority: RoutePriority = .normal) {
        callbacks?.push(AnyViewRoute(erasing: view, priority: priority))
    }
    
    public func presentSheet(_ view: some ViewRoute, priority: RoutePriority = .normal) {
        callbacks?.presentSheet(AnyViewRoute(erasing: view, priority: priority))
    }
    
    public func presentCover(_ view: some ViewRoute, priority: RoutePriority = .normal) {
        callbacks?.presentCover(AnyViewRoute(erasing: view, priority: priority))
    }
    
    public func presentPath(_ path: [some ViewRoute], priority: RoutePriority = .normal) {
        callbacks?.presentPath(path.map({ route in
            AnyViewRoute(erasing: route, priority: priority)
        }))
    }
    
    public func closeSheet() {
        callbacks?.closeSheet()
    }
    
    public func closeFullScreenCover() {
        callbacks?.closeFullScreenCover()
    }
    
    private struct Callbacks {
        let push: (_ view: AnyViewRoute) -> Void
        let pop: () -> Void
        let popToRoot: () -> Void
        let presentSheet: (_ view: AnyViewRoute) -> Void
        let presentCover: (_ view: AnyViewRoute) -> Void
        let switchToTab: (_ id: String) -> Void
        let presentPath: (_ path: [AnyViewRoute]) -> Void
        let closeSheet: () -> Void
        let closeFullScreenCover: () -> Void
    }
}
