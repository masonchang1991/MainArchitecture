//
//  NetworkManager.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case alpha
    case production
    case mock
}

public struct NetworkManager {
    
    static let environment: NetworkEnvironment = .mock
    
//    static var apiProvider: APIProvider.Type {
//        switch environment {
//        case .alpha: fallthrough
//        case .mock: fallthrough
//        case .production:
//            return FormalAPIProvider.self
//        }
//    }
}
