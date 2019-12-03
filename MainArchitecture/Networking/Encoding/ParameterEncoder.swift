//
//  ParameterEncoder.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

