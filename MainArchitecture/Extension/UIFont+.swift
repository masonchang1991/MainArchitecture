//
//  UIFont+.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func PFSCfontBySize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
    
    static func PFSMfontBySize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size)!
    }
    
    static func SLfontBySize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "STHeitiTC-Light", size: size)!
    }
    
}
