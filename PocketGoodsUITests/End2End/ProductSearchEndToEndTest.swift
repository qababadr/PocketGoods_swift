//
//  ProductSearchEndToEndTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-14.
//

final class ProductSearchEndToEndTest: EndToEndTest {
    private var splashScreenRobot: SplashScreenRobot!
    private var productRobot: ProductRobot!

    override func onSetup() {
        splashScreenRobot = SplashScreenRobot(app: app)
        productRobot = ProductRobot(app: app)
    }

    func test_typing_in_search_bar_should_show_product_suggestions() {
        splashScreenRobot.assertHasPassedSplashScreenScene()

        productRobot.assertCanShowProductSuggestions()
    }

    func test_clicking_on_suggested_product_should_navigate_to_product_detail()
    {
        splashScreenRobot.assertHasPassedSplashScreenScene()

        productRobot.assertCanNavigateToProductDetailFromSuggestedProducts()
    }

    func test_submitting_search_query_should_display_matching_products() {
        let searchQuery = "s"
        splashScreenRobot.assertHasPassedSplashScreenScene()

        productRobot.assertCanNavigateToSearchResultScreen(
            searchQuery: searchQuery
        )
        productRobot.assertHasMatchingProducts(searchQuery: searchQuery)
    }

    func
        test_submitting_some_non_existing_product_title_as_search_query_should_show_warning_message()
    {
        let searchQuery = "some non existing product title"
        
        splashScreenRobot.assertHasPassedSplashScreenScene()
        
        productRobot.assertCanNavigateToSearchResultScreen(
            searchQuery: searchQuery
        )
        
        productRobot.assertHasWarningMessage()
    }
}
