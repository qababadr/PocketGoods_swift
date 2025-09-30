//
//  Array.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

extension Array {
    public func distinctBy<Key: Hashable>(_ keySelector: (Element) -> Key)
        -> [Element]
    {
        var seen = Set<Key>()

        return filter { element in
            let key = keySelector(element)

            if seen.contains(key) {
                return false
            } else {
                seen.insert(key)
                return true
            }
        }
    }
}
