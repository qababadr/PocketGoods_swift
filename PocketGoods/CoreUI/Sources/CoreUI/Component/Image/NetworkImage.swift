//
//  NetworkImage.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

public struct NetworkImage<LoadingView: View, ErrorView: View>: View {

    private let url: URL
    private let withFadeInAnimation: Bool
    private let accessibilityIdentifier: String?
    private let errorPlaceHolder: ErrorView
    private let loadingPlaceHolder: LoadingView

    @State
    private var isLoaded: Bool = false

    public init(
        url: URL,
        withFadeInAnimation: Bool = true,
        accessibilityIdentifier: String? = nil,
        @ViewBuilder errorPlaceHolder: @escaping () -> ErrorView = {
            EmptyView()
        },
        @ViewBuilder loadingPlaceHolder: @escaping () -> LoadingView = {
            EmptyView()
        }
    ) {
        self.url = url
        self.withFadeInAnimation = withFadeInAnimation
        self.accessibilityIdentifier = accessibilityIdentifier
        self.errorPlaceHolder = errorPlaceHolder()
        self.loadingPlaceHolder = loadingPlaceHolder()
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                if loadingPlaceHolder is EmptyView {
                    ProgressView().frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                } else {
                    loadingPlaceHolder.frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }
            case .success(let image):
                image
                    .resizable()
                    .opacity(isLoaded ? 1 : 0)
                    .onAppear {
                        if withFadeInAnimation {
                            withAnimation(.easeIn(duration: 0.5)) {
                                isLoaded = true
                            }
                        } else {
                            isLoaded = true
                        }
                    }
                    .accessibilityElement()
                    .accessibilityIdentifier(
                        accessibilityIdentifier ?? url.absoluteString
                    )

            case .failure(let error):
                if errorPlaceHolder is EmptyView {
                    VStack(alignment: .center) {
                        Spacer()

                        Image(systemName: "xmark.circle")
                            .foregroundColor(.theme().error)

                        Text(error.localizedDescription)
                            .foregroundColor(.theme().error)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    errorPlaceHolder.frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }

            @unknown default:
                EmptyView()
            }
        }
    }
}
