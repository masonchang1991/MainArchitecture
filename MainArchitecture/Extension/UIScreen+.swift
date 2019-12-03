//
//  UIScreen+.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // 對比 iphone 8
    static var screenRatio: CGFloat {
        return (UIScreen.main.bounds.width) / CGFloat(375)
    }
}
