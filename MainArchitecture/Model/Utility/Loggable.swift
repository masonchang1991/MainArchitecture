//
//  Loggable.swift
//  HanFans
//
//  Created by Mason on 2019/7/1.
//  Copyright © 2019 han. All rights reserved.
//

import Foundation

enum LogType: Int, Equatable, Comparable {
    case debug = 4
    case info = 3
    case warning = 2
    case error = 1
    case none = 0

    static func < (lhs: LogType, rhs: LogType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

protocol Loggable {
    func log(type: LogType, msg: Any...)
}

extension Loggable {
    func log(type: LogType, msg: Any...) {
        if Logger.level > type {
            let perMsgWithNewline = msg.map({ [$0, "\n"] }).reduce([], { $0 + $1 })
            print("--\(type) Log: \nobject: \(String(describing: self))\nitem: \(perMsgWithNewline)")
        }
    }
}

struct Logger {
    static var level: LogType = .none
}
