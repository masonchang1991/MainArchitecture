//
//  MainCoordinator.swift
//  Gimy
//
//  Created by Mason on 2019/11/14.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation
import UIKit

class GMMainCoordinator: MainCoordinator {
    
    var childCoordinators: [Coordinator] = []

    var tabbarCoordinators: [Coordinator] = []
    
    var currentVisibleCoordinator: Coordinator {
        if let tabbarController = tabbarController {
            let selectedIndex = tabbarController.selectedIndex
            if let tabbarCoordinator = tabbarCoordinators[exist: selectedIndex] {
                return tabbarCoordinator
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    var router: Router
    
    private let cdFactory: CoordinatorFactory
    private let vcFactory: VCFactory
    
    private weak var tabbarController: UITabBarController?
    
    init(router: Router, cdFactory: CoordinatorFactory, vcFactory: VCFactory) {
        self.router = router
        self.cdFactory = cdFactory
        self.vcFactory = vcFactory
    }
    
    func start() {
        
    }
    
    private func setDefaultTabbarCoordinators() {
        
        
    }
}
