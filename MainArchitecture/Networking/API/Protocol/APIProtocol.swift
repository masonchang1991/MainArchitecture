//
//  APIProtocol.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

protocol APIProtocol: class {
    associatedtype Router: NetworkRouter
    var route: Router { get set }
    func getData<DecodableData: Decodable>(_ callback: @escaping (Result<DecodableData?, Router.NetworkError>) -> Void)
    func cancelRequest()
}
