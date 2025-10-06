//
//  TypingText.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

public struct TypingText: View {

    private let text: String
    private let typingSpeed: UInt64

    @State
    private var displayedText: String = ""

    public init(
        text: String,
        typingSpeed: UInt64 = 50_000_000
    ) {
        self.text = text
        self.typingSpeed = typingSpeed
    }

    public var body: some View {
        Text(displayedText)
            .onAppear {
                Task {
                    for char in text {
                        displayedText.append(String(char))
                        try? await Task.sleep(nanoseconds: typingSpeed)
                    }
                }
            }
    }
}

#Preview {
    TypingText(
        text: "Use this library to save your application’s permanent data into SQLite databases. It comes with built-in tools that address common needs:SQL Generation Enhance your application models with persistence and fetching methods, so that you don't have to deal with SQL and raw database rows when you don't want to."
    )
    .font(.bodyMedium)
    .lineSpacing(8)
    .multilineTextAlignment(.center)
    .padding()
}
