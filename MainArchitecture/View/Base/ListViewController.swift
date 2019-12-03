//
//  ListViewController.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

typealias ListControllerViewModel = (ListViewModel & ControllerViewModel)
typealias PagerListControllerViewModel = (ListControllerViewModel & PagerListViewModel)

class ListViewController<T: ListControllerViewModel>: BaseVC<T> {
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModelEvent()
    }
    
    func bindViewModelEvent() {
        viewModel.listUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func bindViewModel(_ viewModel: T) {
        self.viewModel = viewModel
    }
}
