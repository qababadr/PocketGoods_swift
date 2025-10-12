//
//  AuthenticationRepositoryImplTest.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

import Combine
import CoreApp
import XCTest

@testable import AuthenticationFeature

final class AuthenticationRepositoryImplTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var mockCryptoService: CryptoService?
    private var cancellables = Set<AnyCancellable>()
    private var useCases: AuthenticationUseCases?

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()

        mockCryptoService = MockCryptoService()

        let apiService = ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: MockURLProtocol.makeSession())
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()

        let repository = AuthenticationRepositoryImpl(
            apiService: apiService,
            database: memoryDatabase,
            cryptoService: mockCryptoService
        )

        useCases = AuthenticationUseCases(
            login: LoginUseCase(repository: repository),
            register: RegisterUseCase(repository: repository),
            logout: LogoutUseCase(repository: repository),
            clearCachedUser: ClearCachedUserUseCase(repository: repository),
            getAuthenticatedUser: GetAuthenticatedUserUseCase(
                repository: repository
            ),
            getCachedAuthenticatedUser: GetCachedAuthenticatedUserUseCase(
                repository: repository
            )
        )
    }

    func test_login_should_authenticate_user_and_get_correct_user_data()
        async throws
    {
        guard let useCases,
            let memoryDatabase
        else {
            XCTFail("Use cases not initialized")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should authenticate user and get correct user data"
        )

        let correctUserData = MockData
            .loginResponse
            .data
            .user
            .toUser()

        let updatedUser = User(
            id: correctUserData.id,
            name: correctUserData.name,
            email: MockData.correctEmail,
            emailVerifiedAt: correctUserData.emailVerifiedAt,
            wishlist: correctUserData.wishlist
        )

        do {
            let cancellable =
                try await useCases
                .login(
                    email: MockData.correctEmail,
                    password: MockData.correctPassword
                )
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break

                        case .failure(let error):
                            XCTFail("Expected success but got error: \(error)")
                        }
                    },
                    receiveValue: { user in
                        XCTAssertNotNil(user)

                        XCTAssertEqual(
                            user,
                            updatedUser
                        )

                        let cachedUser = try? memoryDatabase.reader.read { db in
                            try UserEntity
                                .including(
                                    all: UserEntity.wishlist
                                        .including(
                                            optional: WishlistItemEntity.product
                                                .including(
                                                    all: ProductEntity.images
                                                )
                                        )
                                )
                                .limit(1)
                                .asRequest(
                                    of: UserWithWishlistAndProductAndImages.self
                                )
                                .fetchOne(db)?
                                .toUser()
                        }
                        XCTAssertNotNil(cachedUser)
                        XCTAssertEqual(
                            user,
                            cachedUser
                        )

                        expectation.fulfill()
                    }
                )

            cancellable.store(in: &cancellables)

            #if swift(>=5.8)
                await fulfillment(of: [expectation])
            #else
                wait(for: [expectation])
            #endif

        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }

    func test_login_user_should_fail_after_wrong_credentials() async throws {
        guard let useCases = useCases else {
            XCTFail("Use cases not initialized")
            return
        }

        let expectation = XCTestExpectation(
            description:
                "Should fail to authenticate user when passing wrong credentials"
        )

        let email = "non_existing_email@email.email"
        let password = "password"

        do {
            let cancellable =
                try await useCases
                .login(
                    email: email,
                    password: password
                )
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            XCTFail(
                                "Expecting no emitted error but got error \(error)"
                            )
                        }
                    },
                    receiveValue: { user in
                        XCTFail(
                            "Expecting error but got user: \(String(describing: user?.email))"
                        )
                    }
                )

            cancellable.store(in: &cancellables)

            #if swift(>=5.8)
                await fulfillment(of: [expectation])
            #else
                wait(for: [expectation])
            #endif

        } catch {
            XCTAssertNotNil(error)
            XCTAssertTrue(error is ApiError)
        }
    }

    func test_getAuthenticatedUser_should_get_the_current_authenticated_user()
        async throws
    {
        guard let useCases,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should get the current authenticated user"
        )

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        await useCases
            .getAuthenticatedUser()
            .sink(
                receiveCompletion: { completion in
                    switch completion {

                    case .finished:
                        break
                    case .failure(let error):
                        XCTFail(
                            "Expecting authenticated user but got error: \(error)"
                        )
                    }
                },
                receiveValue: { resource in
                    switch resource {
                    case .loading(let response):
                        let userData: User? = response as? User
                        XCTAssertNil(userData)
                        break

                    case .success(let response):
                        XCTAssertNotNil(response)
                        XCTAssertEqual(
                            response,
                            MockData.loginResponse.data.user.toUser()
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
            )
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }
    
    func test_getAuthenticatedUser_should_get_no_user_after_wrong_token()
            async throws
    {
        guard let useCases
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should get no authenticated user"
        )
        
        await useCases
            .getAuthenticatedUser()
            .sink(
                receiveCompletion: { completion in
                    switch completion {

                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNotNil(error)
                        expectation.fulfill()
                    }
                },
                receiveValue: { resource in
                    switch resource {
                    case .loading(let response):
                        let userData: User? = response as? User
                        XCTAssertNil(userData)
                        break

                    case .success(let response):
                        XCTFail(
                            "Expecting ApiError but got success: \(String(describing: response))"
                        )
                        break

                    case .error(_, let error):
                        XCTAssertNotNil(error)
                        expectation.fulfill()
                        break

                    default:
                        break
                    }
                }
            )
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }
    
    func test_logout_should_logout_the_current_authenticated_user() async throws
    {
        guard let useCases,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: MockData.token)
        
        let response = try await useCases
            .logout(userId: MockData.userDTO.id)
        
        XCTAssertTrue(response)
        
        let cachedUser = try await memoryDatabase.getCachedUserData()
        
        XCTAssertNil(cachedUser)
    }
    
    func test_logout_should_not_logout_the_current_authenticated_user_after_wrong_token() async throws {
        guard let useCases,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: "Some wrong token")
        
        do {
            let _ = try await useCases
                .logout(userId: MockData.userDTO.id)
            
            XCTFail("Logout should not be successful")
            
        } catch {
            XCTAssertNotNil(error)
            XCTAssertTrue(error is ApiError)
            
            mockCryptoService.saveTokenToKeychain(token: MockData.token)
            
            let cachedUser = try await memoryDatabase.getCachedUserData()
            
            XCTAssertNotNil(cachedUser)
        }
    }
}
