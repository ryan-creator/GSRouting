//
//  AppNavigationRouter+Public.swift
//  GSRouting
//
//  Created by Ryan Cole on 4/12/2024.
//

public extension AppNavigationRouter {

    /// Pops the current view off the navigation stack.
    ///
    /// This function removes the topmost view in the navigation hierarchy, navigating back to the previous view.
    func pop() {
        callbacks?.pop()
    }

    /// Pops all views off the navigation stack and returns to the root view.
    ///
    /// This function clears the navigation stack and navigates directly back to the root of the stack.
    func popToRoot() {
        callbacks?.popToRoot()
    }

    /// Switches the active tab in a tab-based navigation structure.
    ///
    /// - Parameter id: The identifier of the tab to switch to.
    func switchTab(id: String) {
        callbacks?.switchToTab(id)
    }

    /// Pushes a new view onto the navigation stack.
    ///
    /// - Parameters:
    ///   - view: The view to push onto the navigation stack. Must conform to `ViewRoute`.
    ///   - priority: The priority of the navigation action. Defaults to `.normal`.
    func push(_ view: some ViewRoute, priority: ActionPriority = .normal) {
        callbacks?.push(AnyViewRoute(erasing: view, priority: priority))
    }

    /// Presents a new view as a modal sheet.
    ///
    /// - Parameters:
    ///   - view: The view to present as a sheet. Must conform to `ViewRoute`.
    ///   - priority: The priority of the navigation action. Defaults to `.normal`.
    func presentSheet(_ view: some ViewRoute, priority: ActionPriority = .normal) {
        callbacks?.presentSheet(AnyViewRoute(erasing: view, priority: priority))
    }

    /// Presents a new view as a full-screen cover.
    ///
    /// - Parameters:
    ///   - view: The view to present as a full-screen cover. Must conform to `ViewRoute`.
    ///   - priority: The priority of the navigation action. Defaults to `.normal`.
    func presentCover(_ view: some ViewRoute, priority: ActionPriority = .normal) {
        callbacks?.presentCover(AnyViewRoute(erasing: view, priority: priority))
    }

    /// Replaces the current navigation path with a new sequence of views.
    ///
    /// - Parameters:
    ///   - path: An array of views to set as the new navigation path. Each view must conform to `ViewRoute`.
    ///   - priority: The priority of the navigation action. Defaults to `.normal`.
    func presentPath(_ path: [some ViewRoute], priority: ActionPriority = .normal) {
        callbacks?.presentPath(path.map({ route in
            AnyViewRoute(erasing: route, priority: priority)
        }))
    }

    /// Closes the currently presented modal sheet, if any.
    ///
    /// This function dismisses the topmost sheet in the modal presentation stack.
    func closeSheet() {
        callbacks?.closeSheet()
    }

    /// Closes the currently presented full-screen cover, if any.
    ///
    /// This function dismisses the topmost full-screen cover in the modal presentation stack.
    func closeFullScreenCover() {
        callbacks?.closeFullScreenCover()
    }
}
