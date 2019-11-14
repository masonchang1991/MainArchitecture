//
//  ViewModelBindable.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation

protocol ViewModelBindable {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
    func bindViewModel(_ viewModel: ViewModel) 
}
