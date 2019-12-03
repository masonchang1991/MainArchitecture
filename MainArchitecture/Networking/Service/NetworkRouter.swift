//
//  NetworkRouter.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    associatedtype NetworkError: Error
    func request<T: Decodable>(_ route: EndPoint, completion: @escaping ((Result<T?, NetworkError>) -> Void))
    func cancel(_ route: EndPoint)
}
