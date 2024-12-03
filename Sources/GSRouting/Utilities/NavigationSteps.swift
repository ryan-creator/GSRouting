//
//  NavigationSteps.swift
//  GSRouting
//
//  Created by Ryan Cole on 2/12/2024.
//

public enum NavigationStep: Equatable {
    case tab(id: String)
    case push(id: String)
    case sheet(id: String)
    case fullScreen(id: String)
}
