//
//  IGListViewModel.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

//import Foundation
//import UIKit
//import IGListKit
//
//class IGListViewModel<T: ListDiffable>: NSObject, ListViewModel, ListAdapterDataSource {
//    
//    typealias Objects = [T]
//    
//    var objects: Objects = []
//    var listUpdate: (() -> ())?
//    var scrollToTop: (() -> ())?
//    
//    private let emptyLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.text = "目前尚無資料"
//        label.font = UIFont.SLfontBySize(16 * UIScreen.screenRatio)
//        label.backgroundColor = .clear
//        return label
//    }()
//    
//    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        return objects
//    }
//
//    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        fatalError()
//    }
//
//    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        return emptyLabel
//    }
//}
//
//class IGPagerListViewModel<T: ListDiffable>: PagerListViewModel<T> {
//
//    var loadUIState: Observable<LoadUIState> = Observable(.initial)
//    var canRefresh: Bool = true
//    
//    //MARK: - call refresh API, this method must be override
//    func refresh() {
//        fatalError()
//    }
//    
//    //MARK: - call nextPage API, this method must be override
//    func nextPage() {
//        fatalError()
//    }
//    
//    //MARK: - call data reload, this method must be override
//    func reload() {
//        fatalError()
//    }
//    
//    func changeState(to: LoadUIState) {
//        let current = loadUIState.value
//        switch (current, to) {
//        case (_, .initial): break
//        case (.loading, .content): loadUIState.value = to
//        case (.loading(.loadMore), .loading(.loadMore)): return
//        case (.loading(.refresh), .loading(.refresh)): return
//        case (.loading(.reload), .loading(.reload)): return
//        case (_, .loading(.refresh)):
//            loadUIState.value = to
//            refresh()
//        case (_, .loading(.reload)):
//            loadUIState.value = to
//            reload()
//        case (.content(.complete), .loading(.loadMore)): return
//        case (.content(.empty), .loading(.loadMore)): return
//        case (_, .loading(.loadMore)):
//            loadUIState.value = to
//            nextPage()
//        default:
//            loadUIState.value = to
//        }
//    }
//}
