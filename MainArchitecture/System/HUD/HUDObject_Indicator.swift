//
//  HUDObject_Indicator.swift
//  Gimy
//
//  Created by Mason on 2019/11/13.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation

protocol HUDIndicator: HUDObject { }
extension HUDIndicator {
    var style: HUDStyle { return .indicator }
}
