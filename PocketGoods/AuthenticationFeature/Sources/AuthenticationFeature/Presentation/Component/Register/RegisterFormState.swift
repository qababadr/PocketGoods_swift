//
//  RegisterFormState.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import CoreApp

public struct RegisterFormState {
    public var isPasswordVisible: Bool
    public var isConfirmPasswordVisible: Bool
    public var isLoading: Bool
    public var alertText: String
    public var alertVisible: Bool
    public var alertType: RegisterAlertType
    public var name: String
    public var email: String
    public var password: String
    public var confirmPassword: String
    public var shouldValidate: Bool

    public init(
        isPasswordVisible: Bool = false,
        isConfirmPasswordVisible: Bool = false,
        isLoading: Bool = false,
        alertText: String = "",
        alertVisible: Bool = false,
        alertType: RegisterAlertType = .error,
        name: String = "",
        email: String = "",
        password: String = "",
        confirmPassword: String = "",
        shouldValidate: Bool = false
    ) {
        self.isPasswordVisible = isPasswordVisible
        self.isConfirmPasswordVisible = isConfirmPasswordVisible
        self.isLoading = isLoading
        self.alertText = alertText
        self.alertVisible = alertVisible
        self.alertType = alertType
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.shouldValidate = shouldValidate
    }

    public func copy(
        isPasswordVisible: Bool? = nil,
        isConfirmPasswordVisible: Bool? = nil,
        isLoading: Bool? = nil,
        alertText: String? = nil,
        alertVisible: Bool? = nil,
        alertType: RegisterAlertType? = nil,
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        confirmPassword: String? = nil,
        shouldValidate: Bool? = nil
    ) -> RegisterFormState {
        return RegisterFormState(
            isPasswordVisible: isPasswordVisible ?? self.isPasswordVisible,
            isConfirmPasswordVisible: isConfirmPasswordVisible
                ?? self.isConfirmPasswordVisible,
            isLoading: isLoading ?? self.isLoading,
            alertText: alertText ?? self.alertText,
            alertVisible: alertVisible ?? self.alertVisible,
            alertType: alertType ?? self.alertType,
            name: name ?? self.name,
            email: email ?? self.email,
            password: password ?? self.password,
            confirmPassword: confirmPassword ?? self.confirmPassword,
            shouldValidate: shouldValidate ?? self.shouldValidate
        )
    }

    public var hasUsernameError: Bool {
        name.count < 5 && shouldValidate
    }

    public var hasEmailError: Bool {
        !Validator.isValidEmail(email) && shouldValidate
    }

    public var hasPasswordError: Bool {
        !Validator.isValidPassword(password) && shouldValidate
    }

    public var hasConfirmPasswordError: Bool {
        password != confirmPassword && shouldValidate
    }
}
