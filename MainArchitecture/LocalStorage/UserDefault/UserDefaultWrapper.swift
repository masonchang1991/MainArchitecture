//
//  UserDefaultWrapper.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(_ key: String, with defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            if let url = userDefaults.url(forKey: key) as? T {
                return url
            } else {
                guard let value = userDefaults.object(forKey: key) else {
                    return defaultValue
                }
                
                return value as? T ?? defaultValue
            }
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                if let url = newValue as? URL {
                    userDefaults.set(url, forKey: key)
                } else {
                    userDefaults.set(newValue, forKey: key)
                }
            }
        }
    }
}

private protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
