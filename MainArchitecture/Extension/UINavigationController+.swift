//
//  UINavigationController+.swift
//  HanFansForReal
//
//  Created by Mason on 2019/11/20.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setBar(hidden: Bool) -> UINavigationController {
        setNavigationBarHidden(hidden, animated: false)
        return self
    }
    
}
