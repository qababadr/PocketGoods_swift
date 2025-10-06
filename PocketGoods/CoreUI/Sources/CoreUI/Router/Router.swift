//
//  Router.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import Foundation

public final class Router: ObservableObject {
    
    public init() {}
    
    @Published
    public var navigationStack: [Destination] = [.HomeScreen]
    
    
    public func currentDestination() -> Destination? {
        return navigationStack.last
    }
    
    public func navigate(
        to route: Destination,
        onNavigate: @escaping (Destination?) -> Void = { _ in }
    ) {
        guard navigationStack.last != route else { return }
        onNavigate(route)
        navigationStack.append(route)
    }
    
    public func navigateBack(
        onNavigateBack: @escaping () -> Void = { }
    ) {
        if !navigationStack.isEmpty {
            onNavigateBack()
            navigationStack.removeLast()
        }
    }
}
