//
//  Routable.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

fileprivate extension EnvironmentValues {
    @Entry var dismissRoot: (() -> Void)?
}

struct RoutableViewModifier: ViewModifier {
    
    @EnvironmentObject
    private var tabRouter: AppTabRouter
    
    @Environment(\.dismissRoot)
    private var dismissRoot
    
    @Environment(\.dismiss)
    private var dismiss
    
    @StateObject
    private var queueManager = QueueManager()
    
    @StateObject
    private var navRouter = AppNavigationRouter()
    
    @State private var path: [AnyViewRoute] = []
    @State private var trackablePath: [NavigationStep] = []
    
    @State private var sheet: AnyViewRoute?
    @State private var fullScreenCover: AnyViewRoute?
    
    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .sheet(item: $sheet, onDismiss: presentNext, content: sheetView)
                .fullScreenCover(item: $fullScreenCover, onDismiss: presentNext, content: fullScreenCoverView)
                .navigationDestination(for: AnyViewRoute.self, destination: navigationDestinationView)
        }
        .onAppear {
            navRouter.initialize(
                push: pushDestination,
                pop: popDestination,
                popToRoot: popToRootDestination,
                presentSheet: presentSheetView,
                presentCover: presentCoverView,
                switchToTab: switchToTab,
                presentPath: presentPath,
                closeSheet: { dismiss() },
                closeFullScreenCover: { dismiss() }
            )
        }
        .environmentObject(navRouter)
        .environment(\.navigationPath, trackablePath)
        .transformEnvironment(\.dismissRoot, transform: { callback in
            if callback == nil {
                callback = dismissToRoot
            }
        })
        .onChange(of: trackablePath) { newHistory in
            if isLoggingEnabled {
                print(newHistory)
            }
        }
    }
    
    private var presentingOverlay: Bool {
        sheet != nil || fullScreenCover != nil
    }
    
    private var isLoggingEnabled: Bool {
        CommandLine.arguments.contains("--log-navigation")
    }
}

private extension RoutableViewModifier {
    
    func dismissToRoot() {
        dismiss()
        sheet = nil
        fullScreenCover = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            self.path = []
        }
    }
    
    func pushDestination(destination: AnyViewRoute) {
        self.path.append(destination)
        self.trackablePath.append(.push(id: destination.id))
    }

    func popDestination() {
        switch trackablePath.last {
        case .sheet, .fullScreen:
            dismiss()
        default:
            if trackablePath.isEmpty {
                dismiss()
            } else {
                _ = self.path.popLast()
                _ = self.trackablePath.popLast()
            }
        }
    }

    func popToRootDestination() {
        if let dismissRoot {
            dismissRoot()
        } else {
            dismiss()
            self.path = []
            self.trackablePath = []
        }
    }
    
    func presentPath(_ path: [AnyViewRoute]) {
        self.path = path
        self.trackablePath = path.map { .push(id: $0.id) }
    }

    func presentSheetView(sheet: AnyViewRoute) {
        if presentingOverlay {
            self.queueManager.enqueue(route: sheet)
        } else {
            self.sheet = sheet
        }
        self.trackablePath.append(.sheet(id: sheet.id))
    }

    func presentCoverView(cover: AnyViewRoute) {
        if presentingOverlay {
            self.queueManager.enqueue(route: cover)
        } else {
            self.fullScreenCover = cover
        }
        self.trackablePath.append(.fullScreen(id: cover.id))
    }

    func switchToTab(id: String) {
        if let dismissRoot {
            dismissRoot()
        } else {
            dismiss()
            self.trackablePath = []
        }
        self.tabRouter.switchToTab(id: id)
    }
    
    func presentNext() {
        queueManager.dequeue { next in
            switch next.type {
            case .sheet:
                sheet = next
            case .fullScreenCover:
                fullScreenCover = next
            case .none:
                break
            }
        }
    }
    
    func sheetView(_ sheet: AnyViewRoute) -> some View {
        sheet.body.modifier(RoutableViewModifier())
    }
    
    func fullScreenCoverView(_ cover: AnyViewRoute) -> some View {
        cover.body.modifier(RoutableViewModifier())
    }
    
    func navigationDestinationView(_ destination: AnyViewRoute) -> some View {
        destination.body
    }
}
