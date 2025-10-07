//
//  ProductViewModelTest.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import Combine
import CoreApp
import XCTest

@testable import ProductFeature

final class ProductViewModelTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var cancellables = Set<AnyCancellable>()
    private var useCases: ProductUseCases?
    private var viewModel: ProductViewModel?

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()

        let apiService = ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: MockURLProtocol.makeSession())
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()

        let repository = ProductRepositoryImpl(
            apiService: apiService,
            database: memoryDatabase
        )

        useCases = ProductUseCases(
            getProducts: GetProductsUseCase(repository: repository),
            getProduct: GetProductUseCase(repository: repository),
            getSuggestedProducts: GetSuggestedProductsUseCase(
                repository: repository
            ),
            searchProducts: SearchProductsUseCase(repository: repository)
        )
    }

    @MainActor
    func test_getProducts_should_return_success_with_list_of_product_previews()
        async throws
    {
        viewModel = ProductViewModel(useCases: useCases)

        guard let viewModel else { return }

        let expectation = XCTestExpectation(
            description: "Should get products for page 1"
        )

        viewModel.onEvent(event: .getProducts)

        viewModel.$state
            .dropFirst()
            .sink { state in
                if !state.isPageLoading && !state.products.isEmpty {

                    XCTAssertFalse(
                        state.products.isEmpty,
                        "Products should not be empty"
                    )

                    XCTAssertEqual(
                        state.products,
                        MockData
                            .productsPaginationResponse
                            .data
                            .map { $0.toProductPreview() }
                    )

                    expectation.fulfill()
                }

                if let error = state.error {
                    XCTFail("Error occurred: \(error)")
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    @MainActor
    func test_loadProduct_should_return_the_correct_product_detail()
        async throws
    {
        viewModel = ProductViewModel(useCases: useCases)

        guard let viewModel else { return }

        let correctProductDetail = MockData
            .sunGlassesProductResponse
            .data

        let expectation = XCTestExpectation(
            description:
                "Should get product detail for product \(correctProductDetail.title) id \(correctProductDetail.id)"
        )

        viewModel.onEvent(event: .loadProduct(correctProductDetail.id))

        viewModel.$state
            .dropFirst()
            .sink { state in
                if !state.isPageLoading && state.product != nil {

                    XCTAssertNotNil(
                        state.product,
                        "Product should not be nil"
                    )

                    XCTAssertEqual(
                        state.product,
                        correctProductDetail
                    )

                    expectation.fulfill()
                }

                if let error = state.error {
                    XCTFail("Error occurred: \(error)")
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    @MainActor
    func test_searchSuggestions_should_give_suggested_products() async throws {
        viewModel = ProductViewModel(useCases: useCases)

        guard let viewModel else { return }

        let query = "s"

        let expectation = XCTestExpectation(
            description: "Should get suggested products for query '\(query)'"
        )

        var observedStates: [ProductState] = []
        var observedSearchQueries: [String] = []

        viewModel
            .$searchQuery
            .dropFirst()
            .sink { newQuery in
                observedSearchQueries.append(newQuery)
            }
            .store(in: &cancellables)

        viewModel
            .$state
            .dropFirst()
            .sink { state in
                observedStates.append(state)

                if !state.isSearching && !state.suggestedProducts.isEmpty {

                    XCTAssertEqual(
                        state.suggestedProducts,
                        MockData
                            .suggestedProducts(query: query)
                            .data
                            .map { $0.toProductPreview() }
                    )

                    expectation.fulfill()
                }

                if let error = state.error {
                    XCTFail("Error occurred: \(error)")
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        viewModel.searchQuery = query
        viewModel.onEvent(event: .searchSuggestions)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertEqual(observedSearchQueries.last, query)
        XCTAssertTrue(observedStates.count == 2)
        
        if observedStates.count >= 2 {
            let loadingState = observedStates[0]
            let successState = observedStates[1]

            XCTAssertTrue(loadingState.isSearching)
            XCTAssertTrue(loadingState.suggestedProducts.isEmpty)

            XCTAssertFalse(successState.isSearching)
            XCTAssertTrue(!successState.suggestedProducts.isEmpty)

        }
    }

    @MainActor
    func
        test_searchProducts_should_give_non_empty_products_matching_the_search_query()
        async throws
    {
        viewModel = ProductViewModel(useCases: useCases)

        guard let viewModel else { return }

        let query = "s"

        let expectation = XCTestExpectation(
            description:
                "Should get products after submitting search with query '\(query)'"
        )

        var observedStates: [ProductState] = []
        var observedSearchQueries: [String] = []

        viewModel.$searchQuery
            .dropFirst()
            .sink { newQuery in
                observedSearchQueries.append(newQuery)
            }
            .store(in: &cancellables)

        viewModel.$state
            .dropFirst()
            .sink { state in
                observedStates.append(state)

                if !state.isPageLoading && !state.products.isEmpty {
                    XCTAssertEqual(
                        state.products,
                        MockData
                            .searchPaginationResponse(query: query)
                            .data
                            .map { $0.toProductPreview() }
                    )
                    expectation.fulfill()
                }

                if let error = state.error {
                    XCTFail("Error occurred: \(error)")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.searchQuery = query
        viewModel.onEvent(event: .searchProducts)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertEqual(observedSearchQueries.last, query)
        XCTAssertTrue(observedStates.count == 2)
        
        if observedStates.count >= 2 {
            let loadingState = observedStates[0]
            let successState = observedStates[1]

            XCTAssertTrue(loadingState.isPageLoading)
            XCTAssertTrue(loadingState.products.isEmpty)

            XCTAssertFalse(successState.isPageLoading)
            XCTAssertTrue(!successState.products.isEmpty)
        }
    }

    @MainActor
    func
        test_searchProducts_should_give_empty_products_list_when_passing_non_existing_product_title()
        async throws
    {
        viewModel = ProductViewModel(useCases: useCases)

        guard let viewModel else { return }

        let query = "some random product title that does not exist"

        let expectation = XCTestExpectation(
            description:
                "Should get products after submitting search with query '\(query)'"
        )

        var observedStates: [ProductState] = []
        var observedSearchQueries: [String] = []

        viewModel.$searchQuery
            .dropFirst()
            .sink { newQuery in
                observedSearchQueries.append(newQuery)
            }
            .store(in: &cancellables)

        viewModel.$state
            .dropFirst()
            .sink { state in
                observedStates.append(state)

                if !state.isPageLoading {
                    XCTAssertTrue(state.products.isEmpty)
                    expectation.fulfill()
                }

                if let error = state.error {
                    XCTFail("Error occurred: \(error.localizedDescription)")
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        viewModel.searchQuery = query
        viewModel.onEvent(event: .searchProducts)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertEqual(observedSearchQueries.last, query)
        XCTAssertTrue(observedStates.count == 2)
        
        if observedStates.count >= 2 {
            let loadingState = observedStates[0]
            let successState = observedStates[1]

            XCTAssertTrue(loadingState.isPageLoading)
            XCTAssertTrue(loadingState.products.isEmpty)

            XCTAssertFalse(successState.isPageLoading)
            XCTAssertTrue(successState.products.isEmpty)
        }
    }
}
