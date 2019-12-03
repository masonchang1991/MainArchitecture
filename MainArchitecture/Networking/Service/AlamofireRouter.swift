//
//  AlamofireRouter.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

//import Foundation
//import Alamofire
//
//class AlamofireRouter: NetworkRouter, Loggable {
//
//    typealias EndPoint = EndPointType
//    typealias NetworkError = AFError
//
//    private var dataRequests = NSCache<NSURLRequest, DataRequest>()
//    private let lock = NSRecursiveLock()
//
//    func request<D: Decodable>(_ route: EndPoint, completion: @escaping ((Result<D?, NetworkError>) -> Void)) {
//        do {
//            let request = try buildRequest(from: route)
//            lock.lock()
//            if dataRequests.object(forKey: request as NSURLRequest) != nil {
//                completion(.failure(.sessionDeinitialized))
//                return lock.unlock()
//            }
//
//            log(type: .debug, msg: "request url:", request.url ?? "")
//            let request = AlamofireSession.shared.session.request(request).responseDecodable{ [weak self](_ response: DataResponse<D?, AFError>) in
//                guard let self = self else { return }
//                self.lock.lock()
//                self.dataRequests.removeObject(forKey: request as NSURLRequest)
//                self.lock.unlock()
//                completion(response.result)
//            }
//            // MARK: - hold request ref
//            dataRequests.setObject(request, forKey: request as NSURLRequest)
//            lock.unlock()
//        } catch {
//            completion(.failure(AFError.explicitlyCancelled))
//        }
//    }
//
//    func cancel(_ route: EndPoint) {
//        do {
//            let request = try buildRequest(from: route)
//            lock.lock()
//            let dataRequest = dataRequests.object(forKey: request as NSURLRequest)
//            dataRequest?.cancel()
//            dataRequests.removeObject(forKey: request as NSURLRequest)
//            lock.unlock()
//        } catch {
//            log(type: .debug, msg: "AlamofireRouter cancel error", error)
//        }
//    }
//
//    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
//        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path))
//        request.httpMethod = route.method.rawValue
//        do {
//            switch route.task {
//            case .request:
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            case .requestParameters(let bodyParameters,
//                                    let urlParameters):
//                try configureParameters(bodyParameters: bodyParameters,
//                                        urlParameters: urlParameters,
//                                        request: &request)
//            case .requestParametersAndHeaders(let bodyParameters,
//                                              let urlParameters,
//                                              let additionHeaders):
//                addAdditionalHeaders(additionHeaders, request: &request)
//                try configureParameters(bodyParameters: bodyParameters,
//                                        urlParameters: urlParameters,
//                                        request: &request)
//            }
//            return request
//        } catch {
//            throw error
//        }
//    }
//
//    fileprivate func configureParameters(bodyParameters: Parameters?,
//                                         urlParameters: Parameters?,
//                                         request: inout URLRequest) throws {
//
//        do {
//            if let bodyParameters = bodyParameters {
//                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
//            }
//            if let urlParameters = urlParameters {
//                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
//            }
//        } catch {
//            throw error
//        }
//    }
//
//    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?,
//                                          request: inout URLRequest) {
//        guard let headers = additionalHeaders else { return }
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//    }
//}
