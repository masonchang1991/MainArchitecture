//
//  ImageAsset.swift
//  Gimy
//
//  Created by Mason on 2019/11/14.
//  Copyright © 2019 Hancock. All rights reserved.
//

import Foundation
import UIKit

enum ImageAsset: String {
    case app
}

extension UIImage {
    static func asset(_ asset: ImageAsset) -> UIImage? {
        return UIImage(named: asset.rawValue)
    }
    
    func resize(to target: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = target.width / size.width
        let heightRatio = target.height / size.height
        
        let newSize: CGSize = CGSize(width: size.width * widthRatio,
                                     height: size.height * heightRatio)
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
