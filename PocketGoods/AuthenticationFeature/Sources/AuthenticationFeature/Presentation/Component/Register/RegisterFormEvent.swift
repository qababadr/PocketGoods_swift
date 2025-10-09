//
//  RegisterFormEvent.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//


public enum RegisterFormEvent {
    case togglePasswordVisible
    
    case toggleConfirmPasswordVisible
    
    case setAlert(message: String, visible: Bool, alertType: RegisterAlertType)
    
    case register(onRegistered: (String) -> Void, onError: () -> Void)
    
    case onReset
}
