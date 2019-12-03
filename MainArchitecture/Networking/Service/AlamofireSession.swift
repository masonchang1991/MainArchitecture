//
//  AlamofireSession.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

//import Foundation
//import Alamofire
//
//class AlamofireSession {
//
//    static let shared = AlamofireSession()
//
//    static let timeOutForRequest: TimeInterval = 15
//    static let timeOutForResourece: TimeInterval = 15
//
//    lazy var session: Session = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = AlamofireSession.timeOutForRequest
//        configuration.timeoutIntervalForResource = AlamofireSession.timeOutForResourece
//        //MARK: - .reloadIgnoringLocalAndRemoteCacheData not work
//        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
//        configuration.httpShouldSetCookies = false
//        configuration.httpMaximumConnectionsPerHost = 15
//        let session = Session(configuration: configuration)
//        return session
//    }()
//
//    var isConnectedToInternet: Bool {
//        return NetworkReachabilityManager()?.isReachable ?? true
//    }
//}
