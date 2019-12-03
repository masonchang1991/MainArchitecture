//
//  UIImage+.swift
//  HanFansForReal
//
//  Created by Mason on 2019/11/20.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        return self.drawImage(newSize: CGSize(width: newWidth, height: newHeight))
    }
    
    func resizeImage(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        return self.drawImage(newSize: CGSize(width: newWidth, height: newHeight))
    }
    
    private func drawImage(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0);
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //如果resize失敗就傳灰底突出去，在外面顯示asepfit圖
        return newImage ?? self
    }
    
    func getPerfectSizeImage(targetSize: CGSize) -> UIImage {
        let resizeWithHeightimage = self.resizeImage(newHeight: targetSize.height)
        let resizeWithWidthimage = self.resizeImage(newWidth: targetSize.width)
        
        if resizeWithHeightimage.size.height >= targetSize.height &&
            resizeWithHeightimage.size.width >= targetSize.width {
            return resizeWithHeightimage
            
        } else if resizeWithWidthimage.size.height >= targetSize.height &&
            resizeWithWidthimage.size.width >= targetSize.width {
            return resizeWithWidthimage
            
        } else if resizeWithHeightimage.size.height >= resizeWithWidthimage.size.height &&
            resizeWithHeightimage.size.width >= resizeWithWidthimage.size.width {
            return resizeWithHeightimage
            
        } else {
            return resizeWithWidthimage
        }
    }
}
