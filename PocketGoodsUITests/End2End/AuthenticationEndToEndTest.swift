//
//  AuthenticationEndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-17.
//

final class AuthenticationEndToEndTest: EndToEndTest {
    private var splashScreenRobot: SplashScreenRobot!
    private var authRobot: AuthenticationRobot!

    override func onSetup() {
        splashScreenRobot = SplashScreenRobot(app: app)
        authRobot = AuthenticationRobot(app: app)
    }

    func test_user_should_be_able_to_login_when_providing_correct_credentials()
    {
        splashScreenRobot.assertHasPassedSplashScreenScene()

        authRobot.assertCanAuthenticate()
    }

    func test_user_can_register() {
        splashScreenRobot.assertHasPassedSplashScreenScene()

        authRobot.assertCanRegister()
    }

    func test_user_can_logout() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        authRobot.assertCanAuthenticate()
        authRobot.assertCanClickOnLogoutMenuItem()
        authRobot.assertIsLoggedOut()
    }
}
