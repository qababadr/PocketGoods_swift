//
//  Header.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-06.
//

import SwiftUI

public struct Header<SearchInput: View, Toolbar: View>: View {

    private let onLogoClick: () -> Void
    private let searchInput: SearchInput
    private let toolbar: Toolbar
    private let typingText: String

    public init(
        onLogoClick: @escaping () -> Void,
        @ViewBuilder searchInput: @escaping () -> SearchInput,
        @ViewBuilder toolbar: @escaping () -> Toolbar,
        typingText: String
    ) {
        self.onLogoClick = onLogoClick
        self.searchInput = searchInput()
        self.toolbar = toolbar()
        self.typingText = typingText
    }

    public var body: some View {
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                Image("full_logo", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.horizontal, 6)
                    .onTapGesture {
                        onLogoClick()
                    }
                    .accessibilityIdentifier(LocalKeys.appName)
                
                Spacer()
                
                toolbar.zIndex(100)
            }
            
            HStack {
                searchInput.padding(.leading, 65)
                Spacer()
            }
            
            TypingText(text: typingText)
                .font(.bodyLarge)
                .foregroundColor(.theme().onPrimary)
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 100)
                .zIndex(-100)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 70)
        .background(
            Image("blob-bg", bundle: .module)
                .resizable()
                .scaledToFill()
        )
    }
}

private struct HeaderPreview: View {
    @State
    private var value: String = ""

    @State
    private var isProcessing: Bool = false

    public var body: some View {
        ScrollView {
            VStack {
                Header(
                    onLogoClick: {},
                    searchInput: {
                        TextInput(
                            value: $value,
                            label: "Search",
                            onChange: { newValue in
                                Task {
                                    if !newValue.isEmpty {
                                        isProcessing.toggle()
                                        try? await Task.sleep(
                                            nanoseconds: 1_700_000_000
                                        )
                                        isProcessing.toggle()
                                    }
                                }
                            },
                            trailingIconName: "magnify",
                            isProcessing: isProcessing,
                            iconsColor: .theme().secondary,
                            borderColor: .theme().onPrimary,
                            cornerRadius: 25,
                        )
                        .frame(width: 200)
                    },
                    toolbar: {
                        Text("AB")
                            .foregroundColor(.theme().onPrimary)
                            .padding()
                            .frame(width: 44, height: 44)
                            .background(Color.theme().primary)
                            .clipShape(Circle())
                            .padding(.horizontal, 6)
                            .padding(.top, 8)
                    },
                    typingText: LocalKeys.headerText.localized(bundle: .module),
                )
                .frame(height: 400)
                Spacer()
                VStack {
                    Text("content here")
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HeaderPreview()
}
