//
//  NavigationSteps.swift
//  GSRouting
//
//  Created by Ryan Cole on 2/12/2024.
//

/// Represents a step in the navigation hierarchy.
///
/// `NavigationStep` is an enum that defines the different types of navigation actions that can occur within the app.
/// Each case includes an associated `id` string that identifies the destination of the navigation action.
///
/// - Cases:
///   - `tab`: Represents switching to a tab, identified by a unique `id`.
///   - `push`: Represents a push navigation to a new screen, identified by a unique `id`.
///   - `sheet`: Represents presenting a modal sheet, identified by a unique `id`.
///   - `fullScreen`: Represents presenting a full-screen modal, identified by a unique `id`.
public enum NavigationStep: Equatable {
    case tab(id: String)
    case push(id: String)
    case sheet(id: String)
    case fullScreen(id: String)
}
