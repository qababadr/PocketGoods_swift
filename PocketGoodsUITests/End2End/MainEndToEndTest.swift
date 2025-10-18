//
//  MainEndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-14.
//

final class MainEndToEndTest: EndToEndTest {
    
    private var splashScreenRobot: SplashScreenRobot!
    private var productRobot: ProductRobot!
    private var authRobot: AuthenticationRobot!
    
    override func onSetup() {
        splashScreenRobot = SplashScreenRobot(app: app)
        productRobot = ProductRobot(app: app)
        authRobot = AuthenticationRobot(app: app)
    }
    
    func test_splashScreen_should_be_invisible_when_done_loading() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
    }
    
    func test_home_screen_should_have_the_list_of_products() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        productRobot.assertHasLisOfProducts()
    }
    
    func test_can_navigate_to_product_detail() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        productRobot.assertCanNavigateToProductFromList()
    }
    
    func test_authenticated_user_can_switch_theme() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        authRobot.assertCanAuthenticate()
        
        authRobot.assertCanSwitchTheme()
    }
}
