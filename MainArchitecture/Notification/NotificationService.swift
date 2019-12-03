//
//  NotificationService.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

enum NotficationKey: String {
    case app
    var name: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}

struct NotificationService {
    
    static func post(object: Any? = nil, with key: NotficationKey) {
        NotificationCenter.default.post(name: key.name,
                                        object: object)
    }
    
    static func add(target: Any, selector: Selector, key: NotficationKey, for object: Any? = nil) {
        NotificationCenter.default.addObserver(target,
                                               selector: selector,
                                               name: key.name,
                                               object: object)
    }
}
