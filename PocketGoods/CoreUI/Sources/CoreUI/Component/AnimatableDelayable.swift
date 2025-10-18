//
//  AnimatableDelayable.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-18.
//

import SwiftUI

public struct AnimatableDelayable<Content: View>: View {

    public let condition: Bool

    public let deadline: DispatchTime

    public let content: Content

    public init(
        condition: Bool,
        deadline: DispatchTime = .now() + 0.1,
        @ViewBuilder content: @escaping () -> Content,
    ) {
        self.condition = condition
        self.deadline = deadline
        self.content = content()
        self.shouldShow = shouldShow
    }

    @State
    private var shouldShow = false

    public var body: some View {
        VStack {
            if shouldShow && condition {
                content
                    .transition(.scale.combined(with: .opacity))
                    .animation(
                        .interpolatingSpring(
                            stiffness: 200,
                            damping: 22
                        ),
                        value: shouldShow
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                if condition {
                    withAnimation {
                        shouldShow = true
                    }
                }
            }
        }
        .onChange(of: condition) { newCondition in
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                if newCondition {
                    withAnimation {
                        shouldShow = true
                    }
                } else {
                    withAnimation {
                        shouldShow = false
                    }
                }
            }
        }
    }
}

private struct AnimatableDelayablePreview: View {

    @State
    private var list: [String] = []

    @State
    private var isLoading: Bool = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
                        Text("My Items")
                            .font(.bodyLarge)
                            .underline()
                            .padding()

                        AnimatableDelayable(condition: list.isEmpty) {
                            WarningMessage(
                                text: LocalKeys.emptyWishlist.localized(
                                    bundle: .coreUIBundle
                                ),
                                iconName: "information"
                            )
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme().warning)
                            .clipShape(
                                RoundedRectangle(cornerRadius: Theme.medium)
                            )
                            .padding()
                            .shadow(radius: Theme.medium)
                        }

                        ForEach(list, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .padding()
                                    .foregroundColor(.theme().onPrimary)
                                    .background(Color.theme().primary)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: Theme.medium
                                        )
                                    )
                                    .padding()

                                Spacer()

                                Image("delete", bundle: .module)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 26, height: 26)
                                    .foregroundColor(.theme().onPrimary)
                                    .padding()
                                    .background(Color.theme().error)
                                    .clipShape(Circle())
                                    .shadow(radius: Theme.medium)
                                    .onTapGesture {
                                        isLoading = true

                                        DispatchQueue.main.asyncAfter(
                                            deadline: .now() + 1
                                        ) {
                                            let newList = list.filter {
                                                $0 != item
                                            }
                                            list = newList

                                            isLoading = false
                                        }
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear {
            isLoading = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                list = (0...2).map { "Item \($0)" }
                isLoading = false
            }
        }
    }
}

#Preview {
    AnimatableDelayablePreview()
}
