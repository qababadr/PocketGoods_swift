//
//  SplashScreenRobot.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-14.
//
import CoreUI

final class SplashScreenRobot: Robot {

    func assertHasPassedSplashScreenScene() {
        waitAndAssertImageDoesNotExist(
            identifier: UIConstants.splashScreenImageKey,
            timeout: UIConstants.endToEndTimeout
        )
    
        assertHasImage(identifier: LocalKeys.appName)
    }
}
