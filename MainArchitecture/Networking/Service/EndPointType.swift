//
//  EndPointType.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .alpha: fallthrough
        case .mock: fallthrough
        case .production: return ""
        }
    }
}

///HTTPMethod
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

///HTTPHeaders
public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters(
        bodyParameters: Parameters?,
        urlParameters: Parameters
    )
    case requestParametersAndHeaders(
        bodyParameters: Parameters?,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?
    )
}
