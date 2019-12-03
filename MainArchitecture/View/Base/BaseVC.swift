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
class BaseVC<T: ControllerViewModel>: UIViewController, BaseViewController {
    typealias ViewModel = T
    
    var viewModel: T!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(_ viewModel: T) {
        fatalError()
    }
}
