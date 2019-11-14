//
//  AppCoordinator.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation
import UIKit

class GMAppCoordinator: AppCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var topCoordinator: Coordinator {
        //Check if main coordinator exist
        for childCoordinator in childCoordinators {
            if let mainCoordinator = childCoordinator as? MainCoordinator {
                return mainCoordinator.currentVisibleCoordinator
            }
        }
        return self
    }
    
    var router: Router
    private let cdFactory: CoordinatorFactory
    private let vcFactory: VCFactory
    
    init(keyWindow: UIWindow,
         router: Router? = nil,
         cdFactory: CoordinatorFactory = GMCoordinatorFactory(),
         vcFactory: VCFactory = GMVCFactory()) {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        self.router = router ?? GMRouter(rootController: navigationController)
        self.cdFactory = cdFactory
        self.vcFactory = vcFactory
        
        keyWindow.rootViewController = self.router.toPresent()
        keyWindow.makeKeyAndVisible()
    }
    
    func start() {
        
    }
    
}
