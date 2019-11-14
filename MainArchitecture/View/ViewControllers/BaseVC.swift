//
//  BaseVC.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation
import UIKit

protocol BaseViewController: UIViewController, ViewModelBindable { }
class BaseVC<T>: UIViewController, BaseViewController {
    typealias ViewModel = T
    
    var viewModel: T!
    
    func bindViewModel(_ viewModel: T) {
        fatalError()
    }
}
