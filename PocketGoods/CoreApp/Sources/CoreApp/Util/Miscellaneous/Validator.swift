//
//  Validator.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//
import Foundation

public final class Validator {

    public static let defaultPasswordPattern =
        "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$"

    public static func isValidPassword(
        _ password: String,
        pattern: String = defaultPasswordPattern
    ) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)

        return regex?.firstMatch(
            in: password,
            options: [],
            range: NSRange(
                password.startIndex..<password.endIndex,
                in: password
            )
        ) != nil
    }

    public static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }

        let emailPredicate = NSPredicate(
            format: "SELF MATCHES[c] %@",
            "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        )

        return emailPredicate.evaluate(with: email)
    }
}
