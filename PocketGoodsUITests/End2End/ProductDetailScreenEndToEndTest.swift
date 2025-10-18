//
//  ProductDetailScreenEndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-14.
//

final class ProductDetailScreenEndToEndTest: EndToEndTest {
    private var splashScreenRobot: SplashScreenRobot!
    private var productRobot: ProductRobot!

    override func onSetup() {
        splashScreenRobot = SplashScreenRobot(app: app)
        productRobot = ProductRobot(app: app)
    }
    
    func test_product_detail_screen_should_have_correct_detail() {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        productRobot.assertCanNavigateToProductFromList()
        
        productRobot.assertHasCorrectDetail()
    }
}
