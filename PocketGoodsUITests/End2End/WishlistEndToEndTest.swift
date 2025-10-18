//
//  WishlistEndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-17.
//

final class WishlistEndToEndTest: EndToEndTest {
    private var splashScreenRobot: SplashScreenRobot!
    private var authRobot: AuthenticationRobot!
    private var productRobot: ProductRobot!
    private var wishlistRobot: WishlistRobot!

    override func onSetup() {
        splashScreenRobot = SplashScreenRobot(app: app)
        authRobot = AuthenticationRobot(app: app)
        productRobot = ProductRobot(app: app)
        wishlistRobot = WishlistRobot(app: app)
    }

    func test_authenticated_user_can_toggle_wishlist() {
        splashScreenRobot.assertHasPassedSplashScreenScene()

        authRobot.assertCanAuthenticate()

        wishlistRobot.assertCanRemoveProductFromWishlist()
        wishlistRobot.assertCanAddProductToWishlist()
    }

    func
        test_authenticated_user_can_navigate_to_wishlist_manager_screen_and_delete_product_from_wishlist()
    {
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        authRobot.assertCanAuthenticate()
        authRobot.assertCanClickOnWishlistMenuItem()
        
        wishlistRobot.assertCanDeleteProductFromAuthenticatedUserWishlist()
    }
}
