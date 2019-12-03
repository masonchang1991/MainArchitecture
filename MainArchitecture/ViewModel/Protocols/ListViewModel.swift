//
//  IGListViewModel.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation

protocol ListViewModel {
    associatedtype Objects
    var objects: Objects { get set }
    var listUpdate: (() -> ())? { get set }
    var scrollToTop: (() -> ())? { get set }
}

protocol PagerListViewModel: ListViewModel {
    var loadUIState: Observable<LoadUIState> { get set }
    var canRefresh: Bool { get set }
    func refresh()
    func nextPage()
    func reload()
    func changeState(to: LoadUIState)
}
