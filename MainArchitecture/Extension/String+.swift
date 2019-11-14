//
//  String+.swift
//  Gimy
//
//  Created by Mason on 2019/11/14.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
