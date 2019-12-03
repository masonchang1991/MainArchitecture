//
//  IGListViewController.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

//import Foundation
//import UIKit
//import IGListKit
//
//class IGListViewController<T: ListControllerViewModel>: ListViewController<T> {
//    
//    lazy var adapter: ListAdapter = {
//        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
//    }()
//    
//    override func bindViewModelEvent() {
//        viewModel.listUpdate = { [weak self] in
//            self?.adapter.performUpdates(animated: true, completion: nil)
//        }
//    }
//    
//    private func setupIGAdapter() {
//        adapter.collectionView = collectionView
//        adapter.dataSource = viewModel
//    }
//    
//    override func bindViewModel(_ viewModel: T) {
//        self.viewModel = viewModel
//        setupIGAdapter()
//    }
//}
//
//class IGPagerListViewController<T: PagerListControllerViewModel>: IGListViewController<T>, UIScrollViewDelegate {
//    
//    private var disposableObservers: Disposal = []
//    
//    let refreshControl = UIRefreshControl()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setObservers()
//        setupEventsBinding()
//        adapter.scrollViewDelegate = self
//    }
//    
//    private func setupEventsBinding() {
//        if viewModel.canRefresh {
//            collectionView.refreshControl = refreshControl
//            collectionView.refreshControl?.backgroundColor = .white
//            collectionView.refreshControl?.largeContentTitle = "資料刷新中".localize
//            collectionView.refreshControl?.attributedTitle = NSAttributedString(
//                string: "資料刷新中".localize,
//                attributes: [.foregroundColor : UIColor.blue.withAlphaComponent(0.3)])
//            refreshControl.addTarget(
//                self,
//                action: #selector(pullRefresh),
//                for: .valueChanged)
//        } else {
//            collectionView.refreshControl = nil
//        }
//        
//        viewModel.scrollToTop = { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.setContentOffset(.zero, animated: false)
//        }
//    }
//    
//    private func setObservers() {
//        viewModel.loadUIState.observe(.main) { [weak self](newState, oldState) in
//            guard let self = self else { return }
//            guard let oldState = oldState else {
//                self.adapter.performUpdates(animated: true, completion: nil)
//                return
//            }
//            
//            if newState != .loading(.refresh) {
//                self.refreshControl.endRefreshing()
//            }
//            
//            if newState != oldState {
//                self.adapter.performUpdates(animated: true, completion: nil)
//            }
//            
//        }.add(to: &disposableObservers)
//    }
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
//        
//        switch viewModel.loadUIState.value {
//        case .loading(_): return
//        default:
//            if distance < 200 {
//                viewModel.changeState(to: .loading(.loadMore))
//                adapter.performUpdates(animated: true, completion: nil)
//            }
//        }
//    }
//    
//    @objc func pullRefresh() {
//        viewModel.changeState(to: .loading(.refresh))
//    }
//}
