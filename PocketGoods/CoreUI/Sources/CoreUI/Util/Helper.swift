//
//  Helper.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

extension String {
    public func stringAvatar() -> String {
        let parts = trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        switch parts.count {
        case 2...:
            let firstInitial = parts[0].first?.uppercased() ?? ""
            let secondInitial = parts[1].first?.uppercased() ?? ""
            return firstInitial + secondInitial

        case 1:
            return String(parts[0].prefix(2).uppercased())

        default:
            return ""
        }
    }
}
