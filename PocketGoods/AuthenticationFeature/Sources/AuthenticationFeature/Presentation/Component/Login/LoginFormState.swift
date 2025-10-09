//
//  LoginFormState.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import CoreApp

public struct LoginFormState {
    public var isPasswordVisible: Bool
    public var isLoading: Bool
    public var alertText: String
    public var alertVisible: Bool
    public var email: String
    public var password: String
    public var shouldValidate: Bool

    public init(
        isPasswordVisible: Bool = false,
        isLoading: Bool = false,
        alertText: String = "",
        alertVisible: Bool = false,
        email: String = "",
        password: String = "",
        shouldValidate: Bool = false
    ) {
        self.isPasswordVisible = isPasswordVisible
        self.isLoading = isLoading
        self.alertText = alertText
        self.alertVisible = alertVisible
        self.email = email
        self.password = password
        self.shouldValidate = shouldValidate
    }

    public func copy(
        isPasswordVisible: Bool? = nil,
        isLoading: Bool? = nil,
        alertText: String? = nil,
        alertVisible: Bool? = nil,
        email: String? = nil,
        hasEmailError: Bool? = nil,
        password: String? = nil,
        hasPasswordError: Bool? = nil,
        shouldValidate: Bool? = nil
    ) -> LoginFormState {
        return LoginFormState(
            isPasswordVisible: isPasswordVisible ?? self.isPasswordVisible,
            isLoading: isLoading ?? self.isLoading,
            alertText: alertText ?? self.alertText,
            alertVisible: alertVisible ?? self.alertVisible,
            email: email ?? self.email,
            password: password ?? self.password,
            shouldValidate: shouldValidate ?? self.shouldValidate
        )
    }

    public var hasEmailError: Bool {
        !Validator.isValidEmail(email) && shouldValidate
    }

    public var hasPasswordError: Bool {
        password.isEmpty && shouldValidate
    }
}
