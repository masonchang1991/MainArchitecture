//
//  LoadUIState.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

enum LoadUIState {
    
    enum LoadingState: Equatable {
        case refresh, loadMore, reload
    }
    
    enum ContentState: Equatable {
        case hasMore, complete, empty
    }
    
    case initial
    case loading(LoadingState)
    case content(ContentState)
    case error(Error)
    
    public static func ==(lhs: LoadUIState, rhs: LoadUIState) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(a), .loading(b)):
            return a == b
        case let (.content(a), .content(b)):
            return a == b
        case (.initial, .initial):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
    
    public static func !=(lhs: LoadUIState, rhs: LoadUIState) -> Bool {
        return !(lhs == rhs)
    }
}
import Foundation
