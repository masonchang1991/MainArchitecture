//
//  UIColor+.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}
