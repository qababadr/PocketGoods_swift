//
//  ModalController.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import Foundation
import SwiftUI

@MainActor
public class ModalController: ObservableObject{
    
    @Published
    public var isPresented: Bool = false
    
    private var contentBuilder: (() -> AnyView)? = nil
    
    public var content: AnyView? {
        contentBuilder?()
    }

    public init() {}
    
    public func show<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.contentBuilder = { AnyView(content()) }
        withAnimation(.easeInOut(duration: 0.3)) {
            self.isPresented = true
        }
    }
 
    public func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.isPresented = false
        }
        self.contentBuilder = nil
    }
}
