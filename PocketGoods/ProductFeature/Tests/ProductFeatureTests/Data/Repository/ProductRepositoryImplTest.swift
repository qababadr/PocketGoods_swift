//
//  ProductRepositoryImplTest.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//

import Combine
import CoreApp
import XCTest

@testable import ProductFeature

final class ProductRepositoryImplTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var cancellables = Set<AnyCancellable>()
    private var useCases: ProductUseCases?

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

    func test_getProducts_should_return_success_with_list_of_product_previews()
        async throws
    {
        guard let useCases else {
            return
        }

        let expectation = XCTestExpectation(
            description: "Should get products for page 1"
        )

        await useCases.getProducts(page: 1)
            .sink { (resource: Resource<PaginationResponse<ProductPreview>>) in
                switch resource {
                case .loading(let response):
                    XCTAssertNotNil(response)
                    XCTAssertTrue(response!.data.isEmpty)
                    break

                case .success(let response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(
                        response.data,
                        MockData
                            .productsPaginationResponse
                            .data
                            .map { $0.toProductPreview() }
                    )
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expecting success, but got error: \(String(describing: error))"
                    )
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func test_getProduct_should_return_the_correct_cached_product_detail()
        async throws
    {
        guard let useCases,
            let memoryDatabase
        else {
            return
        }

        let correctProductDetail = MockData.sunGlassesProductResponse.data

        let expectation = XCTestExpectation(
            description:
                "Should get product detail for product "
                + "\(correctProductDetail.title) id \(correctProductDetail.id)"
        )

        await useCases.getProduct(id: correctProductDetail.id)
            .sink { (resource: Resource<Product?>) in
                switch resource {
                case .loading(let response):
                    let product = response as? Product
                    XCTAssertNil(product)
                    break

                case .success(let product):
                    XCTAssertNotNil(product)
                    XCTAssertEqual(
                        product,
                        correctProductDetail
                    )

                    let cachedProduct = try? memoryDatabase.reader
                        .read { db in
                            try ProductEntity
                                .including(all: ProductEntity.images)
                                .filter(id: correctProductDetail.id)
                                .asRequest(of: ProductWithImages.self)
                                .fetchOne(db)
                        }?.toProduct()

                    XCTAssertNotNil(cachedProduct)
                    XCTAssertEqual(
                        product,
                        cachedProduct
                    )
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expected success, but got error: \(String(describing: error))"
                    )
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func test_getProduct_should_return_error_when_passing_non_existing_product()
        async throws
    {
        guard let useCases else {
            return
        }

        let id = 100 as Int64

        let expectation = XCTestExpectation(
            description:
                "Should not get product detail for unknown product with id: \(id)"
        )

        await useCases.getProduct(id: id)
            .sink { (resource: Resource<Product?>) in
                switch resource {
                case .loading(let response):
                    let product = response as? Product
                    XCTAssertNil(product)
                    break

                case .success(_):
                    XCTFail("Expected error, but got success")
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func test_getSuggestedProducts_should_give_suggested_products() async throws
    {
        guard let useCases else {
            return
        }

        let query = "s"

        let expectation = XCTestExpectation(
            description:
                "Should get non empty list of suggested products matching query: \(query)"
        )

        await useCases.getSuggestedProducts(query: query)
            .sink { (resource: Resource<[ProductPreview]>) in
                switch resource {
                case .loading(let suggestedProducts):
                    XCTAssertTrue(suggestedProducts?.isEmpty ?? false)
                    break

                case .success(let suggestedProducts):
                    XCTAssertFalse(suggestedProducts.isEmpty)
                    XCTAssertEqual(
                        suggestedProducts,
                        MockData
                            .suggestedProducts(query: query)
                            .data
                            .map { $0.toProductPreview() }
                    )
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expect success but got error: \(String(describing: error?.localizedDescription))"
                    )
                    expectation.fulfill()
                    break

                default: break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func
        test_getSuggestedProducts_should_give_no_suggestion_when_passing_random_non_existing_product_title()
        async throws
    {

        guard let useCases else {
            return
        }

        let query = "some random text input"

        let expectation = XCTestExpectation(
            description:
                "Should get empty list of suggested products matching query: \(query)"
        )

        await useCases.getSuggestedProducts(query: query)
            .sink { (resource: Resource<[ProductPreview]>) in
                switch resource {
                case .loading(let suggestedProducts):
                    XCTAssertTrue(suggestedProducts?.isEmpty ?? false)
                    break

                case .success(let suggestedProducts):
                    XCTAssertTrue(suggestedProducts.isEmpty)
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expect success but got error: \(String(describing: error?.localizedDescription))"
                    )
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func
        test_searchProducts_should_give_non_empty_products_matching_the_search_query()
        async throws
    {
        guard let useCases else {
            return
        }

        let query = "s"
        let page = 1

        let expectation = XCTestExpectation(
            description:
                "Should get non empty list of searched products matching query: \(query)"
        )

        await useCases.searchProducts(query: query, page: page)
            .sink { (resource: Resource<PaginationResponse<ProductPreview>>) in
                switch resource {
                case .loading(let response):
                    XCTAssertNotNil(response)
                    XCTAssertTrue(response!.data.isEmpty)
                    break

                case .success(let response):
                    XCTAssertFalse(response.data.isEmpty)
                    XCTAssertEqual(
                        response.data,
                        MockData.searchPaginationResponse(query: query)
                            .data
                            .map({ $0.toProductPreview() })
                    )
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expect success but got error: \(String(describing: error))"
                    )
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func
        test_searchProducts_should_give_empty_products_for_non_existing_products()
        async throws
    {
        guard let useCases else {
            return
        }

        let query = "some non existing product title"
        let page = 1

        let expectation = XCTestExpectation(
            description:
                "Should get non empty list of searched products matching query: \(query)"
        )

        await useCases.searchProducts(query: query, page: page)
            .sink { (resource: Resource<PaginationResponse<ProductPreview>>) in
                switch resource {
                case .loading(let response):
                    XCTAssertNotNil(response)
                    XCTAssertTrue(response!.data.isEmpty)
                    break
                case .success(let response):
                    XCTAssertTrue(response.data.isEmpty)
                    expectation.fulfill()
                    break

                case .error(_, let error):
                    XCTFail(
                        "Expect success but got error: \(String(describing: error?.localizedDescription))"
                    )
                    expectation.fulfill()
                    break

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }
}
