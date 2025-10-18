//
//  Navigation.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import SwiftUI

extension Navigation {
    func mainContentMinHeight(_ height: CGFloat) -> Self {
        withMainContentMinHeight(height)
    }
}

struct Navigation<
    Data: Hashable,
    Header: View,
    MainContent: View,
    Footer: View
>: View {

    @Binding
    var path: [Data]

    let root: Data
    let header: Header
    let mainContent: (Data) -> MainContent
    let footer: Footer
    let navigationBarHidden: Bool
    let scrollableID: String

    private var mainContentMinHeight: CGFloat

    init(
        path: Binding<[Data]>,
        root: Data,
        @ViewBuilder header: () -> Header,
        @ViewBuilder mainContent: @escaping (Data) -> MainContent,
        @ViewBuilder footer: () -> Footer,
        navigationBarHidden: Bool = true,
        scrollableID: String = "scrollableID",
        mainContentMinHeight: CGFloat = 300

    ) {
        _path = path
        self.root = root
        self.header = header()
        self.mainContent = mainContent
        self.footer = footer()
        self.navigationBarHidden = navigationBarHidden
        self.scrollableID = scrollableID
        self.mainContentMinHeight = mainContentMinHeight
    }

    var body: some View {
        NavigationStack(path: $path) {
            Spacer()
                .navigationDestination(for: Data.self) { data in
                    ScrollView {
                        VStack {
                            header

                            mainContent(data).frame(
                                minHeight: mainContentMinHeight
                            )

                            footer
                        }
                    }
                    .navigationBarHidden(navigationBarHidden)
                    .accessibilityIdentifier(scrollableID)
                    .ignoresSafeArea()
                    .background(Color.theme().background)
                }
                .onChange(of: path) { _, newPath in
                    if newPath.isEmpty {
                        path = [root]
                    }
                }
        }
    }

    func withMainContentMinHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy.mainContentMinHeight = height
        return copy
    }
}
