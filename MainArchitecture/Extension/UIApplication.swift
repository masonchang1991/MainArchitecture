//
//  UIApplication.swift
//  HanFansForReal
//
//  Created by Mason on 2019/11/20.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static var sceneKeyWindow: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
