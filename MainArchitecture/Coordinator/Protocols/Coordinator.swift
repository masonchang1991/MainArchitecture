//
//  Coordinator.swift
//  HanFans
//
//  Created by Mason on 2019/7/1.
//  Copyright © 2019 han. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class, Identifiable {
    var childCoordinators: [Coordinator] { get set }
    var router: Router { get }
    func start()
    func start(with deepLinkOption: [String])
}

extension Coordinator {
    
    func start(with deepLinkOption: [String]) {
        start()
    }
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty,
            let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

protocol AppCoordinator: Coordinator {
    var topCoordinator: Coordinator { get }
}

protocol MainCoordinator: Coordinator {
    /// the most top vc's coordinator
    var currentVisibleCoordinator: Coordinator { get }
    /// For Tabbar item coordinators
    var tabbarCoordinators: [Coordinator] { get set }
}
