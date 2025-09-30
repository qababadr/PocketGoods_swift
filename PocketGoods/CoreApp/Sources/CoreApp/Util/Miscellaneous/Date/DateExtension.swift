//
//  DateExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

extension String {
    public func toDate(format: String = "dd-MM-yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
