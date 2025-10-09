//
//  LoginFormEvent.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//


public enum LoginFormEvent {
    case togglePasswordVisible
    case setAlert(message: String, visible: Bool)
    case login(onError: (Error) -> Void)
}
