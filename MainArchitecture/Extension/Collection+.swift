//
//  Collection+.swift
//  Gimy
//
//  Created by Mason on 2019/11/14.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
