//
//  PocketGoodsAppState.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-12.
//
import CoreUI

struct PocketGoodsAppState {
    let isPageLoading: Bool
    var isDarkTheme: Bool
    let isSplashScreenVisible: Bool
    let latestVisitedScreen: Destination

    init(
        isPageLoading: Bool = false,
        isDarkTheme: Bool = false,
        isSplashScreenVisible: Bool = true,
        latestVisitedScreen: Destination = .HomeScreen
    ) {
        self.isPageLoading = isPageLoading
        self.isDarkTheme = isDarkTheme
        self.isSplashScreenVisible = isSplashScreenVisible
        self.latestVisitedScreen = latestVisitedScreen
    }

    func copy(
        isPageLoading: Bool? = nil,
        isDarkTheme: Bool? = nil,
        isSplashScreenVisible: Bool? = nil,
        latestVisitedScreen: Destination? = nil
    ) -> PocketGoodsAppState {
        return PocketGoodsAppState(
            isPageLoading: isPageLoading ?? self.isPageLoading,
            isDarkTheme: isDarkTheme ?? self.isDarkTheme,
            isSplashScreenVisible: isSplashScreenVisible
                ?? self.isSplashScreenVisible,
            latestVisitedScreen: latestVisitedScreen ?? self.latestVisitedScreen
        )
    }
}
