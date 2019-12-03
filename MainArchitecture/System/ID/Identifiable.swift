//
//  Identifiable.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

// MARK: - Identifiable

public protocol Identifiable {
    
    // MARK: Property
    
    static var identifier: String { get }
    
}

// MARK: - Identifiable (Default Implementation)

public extension Identifiable {
    
    static var identifier: String { return String(describing: self) }
    
}
