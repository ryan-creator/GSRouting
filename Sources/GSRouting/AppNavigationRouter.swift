//
//  AppNavigationRouter.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

@MainActor
public final class AppNavigationRouter: ObservableObject {
    var callbacks: Callbacks?
    
    func initialize(
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
    
    struct Callbacks {
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
