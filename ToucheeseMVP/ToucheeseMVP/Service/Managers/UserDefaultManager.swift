//
//  UserDefaultManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/11/25.
//

import Foundation

struct UserDefaultsManager {
    static func set<T>(_ value: T, for key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func get<T>(_ key: UserDefaultsKey) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    static func remove(_ key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

enum UserDefaultsKey: String {
    case loginedPlatform
}
