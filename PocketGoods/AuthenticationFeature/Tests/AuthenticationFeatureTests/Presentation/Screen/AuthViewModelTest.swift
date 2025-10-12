//
//  AuthViewModelTest.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import Combine
import CoreApp
import XCTest

@testable import AuthenticationFeature

final class AuthViewModelTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var mockCryptoService: CryptoService?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: AuthViewModel?
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

    @MainActor
    func test_login_should_authenticate_user() async throws {
        viewModel = AuthViewModel(useCases: useCases)

        guard let viewModel,
            let memoryDatabase
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should authenticate user and get correct user data"
        )

        let loginEventExpectation = XCTestExpectation(
            description: "Should fire one time event when successful login"
        )

        var observedLoginStates: [LoginFormState] = []
        var observedAuthStates: [AuthState] = []

        var loginSuccessUser: User?

        viewModel
            .loginSuccessSubject
            .sink { user in
                loginSuccessUser = user
                loginEventExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel
            .$authState
            .dropFirst()
            .sink { (state: AuthState) in
                observedAuthStates.append(state)

                Task {
                    if let user = state.authenticatedUser {
                        let cachedUser =
                            try await memoryDatabase.getCachedUserData()

                        XCTAssertEqual(user, cachedUser)
                        expectation.fulfill()

                    }
                }

            }
            .store(in: &cancellables)

        viewModel
            .$loginFormState
            .dropFirst()
            .sink { (state: LoginFormState) in
                observedLoginStates.append(state)
            }
            .store(in: &cancellables)

        viewModel.loginFormState = viewModel.loginFormState.copy(
            email: MockData.correctEmail
        )

        viewModel.loginFormState = viewModel.loginFormState.copy(
            password: MockData.correctPassword
        )

        viewModel.onLoginFormEvent(
            event: .login(onError: { error in
                XCTFail(
                    "Expecting no error but got \(error)"
                )
            })
        )

        #if swift(>=5.8)
            await fulfillment(of: [expectation, loginEventExpectation])
        #else
            wait(for: [expectation, loginEventExpectation])
        #endif

        XCTAssertTrue(
            observedLoginStates.contains { $0.email == MockData.correctEmail }
        )
        XCTAssertTrue(
            observedLoginStates.contains {
                $0.password == MockData.correctPassword
            }
        )

        Task {
            XCTAssertNotNil(loginSuccessUser)
            let cachedUser =
                try await memoryDatabase.getCachedUserData()
            XCTAssertEqual(loginSuccessUser, cachedUser)
        }
    }

    @MainActor
    func test_login_should_fail_after_passing_wrong_credentials() async throws {
        viewModel = AuthViewModel(useCases: useCases)

        guard let viewModel,
            let memoryDatabase
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description:
                "Should not authenticate user and passing incorrect credentials"
        )

        var observedLoginStates: [LoginFormState] = []
        var observedAuthStates: [AuthState] = []

        let email = "non_existingEmail@email.email"
        let password = "password"

        viewModel
            .$authState
            .dropFirst()
            .sink { (state: AuthState) in
                observedAuthStates.append(state)
                if let user = state.authenticatedUser {
                    XCTFail("expecting no user data but got \(user)")
                }
            }
            .store(in: &cancellables)

        viewModel
            .$loginFormState
            .dropFirst()
            .sink { state in
                observedLoginStates.append(state)
            }
            .store(in: &cancellables)

        viewModel.loginFormState = viewModel.loginFormState.copy(
            email: email
        )

        viewModel.loginFormState = viewModel.loginFormState.copy(
            password: password
        )

        viewModel.onLoginFormEvent(
            event: .login(
                onError: { error in
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                })
        )

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertTrue(observedLoginStates.contains { $0.email == email })
        XCTAssertTrue(observedLoginStates.contains { $0.password == password })

        Task {
            let cachedUser = try await memoryDatabase.getCachedUserData()
            XCTAssertNil(cachedUser)
        }
    }

    @MainActor
    func test_register_should_signup_user() async throws {
        viewModel = AuthViewModel(useCases: useCases)

        guard let viewModel else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should authenticate user and get correct user data"
        )

        var observedRegisterStates: [RegisterFormState] = []

        let username = "some user name"
        let email = "some_new_email@email.email"
        let password = "Password@123"

        viewModel
            .$registerFormState
            .dropFirst()
            .sink { state in
                observedRegisterStates.append(state)
            }
            .store(in: &cancellables)

        viewModel.registerFormState = viewModel.registerFormState.copy(
            name: username
        )

        viewModel.registerFormState = viewModel.registerFormState.copy(
            email: email
        )

        viewModel.registerFormState = viewModel.registerFormState.copy(
            password: password
        )

        viewModel.registerFormState = viewModel.registerFormState.copy(
            confirmPassword: password
        )

        viewModel.onRegisterFormEvent(
            event: .register(
                onRegistered: { registeredUsername in
                    XCTAssertEqual(username, registeredUsername)
                    expectation.fulfill()
                },
                onError: {
                    XCTFail("expecting no error")
                }
            )
        )

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertTrue(observedRegisterStates.contains { $0.name == username })
        XCTAssertTrue(observedRegisterStates.contains { $0.email == email })
        XCTAssertTrue(
            observedRegisterStates.contains { $0.password == password }
        )
        XCTAssertTrue(
            observedRegisterStates.contains { $0.confirmPassword == password }
        )
    }

    @MainActor
    func test_logout_should_sign_out_user() async throws {
        viewModel = AuthViewModel(useCases: useCases)

        guard let viewModel,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        let expectation = XCTestExpectation(
            description: "User should be logged out"
        )

        Task {
            let existingUser = try await memoryDatabase.getCachedUserData()

            guard let cachedUser = existingUser else {
                XCTFail("No user to log out")
                return
            }

            viewModel.onAuthEvent(
                event: .onLogout(
                    userId: cachedUser.id,
                    onLoggedOut: {
                        expectation.fulfill()
                    },
                    onError: {
                        XCTFail("Expecting no error but got one")
                    }
                )
            )

            #if swift(>=5.8)
                await fulfillment(of: [expectation])
            #else
                wait(for: [expectation])
            #endif

            let userAfterLogout = try await memoryDatabase.getCachedUserData()
            XCTAssertNil(
                userAfterLogout,
                "User should be removed from cache after logout"
            )
        }
    }

    @MainActor
    func test_logout_should_not_sign_out_user_after_passing_wrong_token()
        async throws
    {
        viewModel = AuthViewModel(useCases: useCases)

        guard let viewModel,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "User should not be allowed to log out"
        )

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: "some wrong token")

        Task {
            let existingUser = try await memoryDatabase.getCachedUserData()
            guard let cachedUser = existingUser else {
                XCTFail("No user to log out")
                return
            }

            viewModel.onAuthEvent(
                event: .onLogout(
                    userId: cachedUser.id,
                    onLoggedOut: {
                        XCTFail("Expecting error but got success instead")
                    },
                    onError: {
                        expectation.fulfill()
                    }
                )
            )

            #if swift(>=5.8)
                await fulfillment(of: [expectation])
            #else
                wait(for: [expectation])
            #endif

            let userAfterLogout = try await memoryDatabase.getCachedUserData()
            XCTAssertNotNil(
                userAfterLogout,
                "User should not be removed from cache after logout"
            )
        }
    }
}
