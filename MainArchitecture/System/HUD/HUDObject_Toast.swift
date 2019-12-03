//
//  Toast.swift
//  HanFans
//
//  Created by Mason on 2019/7/31.
//  Copyright © 2019 han. All rights reserved.
//

import Foundation
import UIKit

protocol HUDToast: HUDObject {
    var message: String { get set }
}
extension HUDToast {
    var style: HUDStyle { return .toast }
}

class GMToast: UIView, HUDToast {
    
    enum DisplayStyle {
        case normal
    }
    
    fileprivate static let insets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    fileprivate static let font = UIFont.systemFont(ofSize: 17)
    
    var hudId: String
    var hudDescription: String
    var message: String
    var font: UIFont
    var showAnimation: UIViewPropertyAnimator?
    var moveAnimation: UIViewPropertyAnimator?
    var dismissAnimation: UIViewPropertyAnimator?
    
    let toastLabel: UILabel = UILabel()
    
    let displayStyle: DisplayStyle
    
    init(id: String, description: String = "", message: String, font: UIFont = GMToast.font, displayStyle: DisplayStyle = .normal) {
        self.hudId = id
        self.hudDescription = description
        self.message = message
        self.font = font
        self.displayStyle = displayStyle
        let frame = CGRect(origin: .zero,
                           size: GMToast.textSize(ceil(UIScreen.width),
                                                  text: message))
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        toastLabel.frame = bounds.inset(by: GMToast.insets)
        layer.cornerRadius = frame.height / 4
    }
    
    func setupViews() {
        clipsToBounds = true
        
        addSubview(toastLabel)
        
        switch displayStyle {
        case .normal:
            backgroundColor = UIColor.black.withAlphaComponent(0.56)
            toastLabel.numberOfLines = 0
            toastLabel.backgroundColor = .clear
            toastLabel.textColor = UIColor.white.withAlphaComponent(0.78)
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.font = font
        }
    }
    
    private static func textSize(_ maxTextWidth: CGFloat, givenWidth: CGFloat = .greatestFiniteMagnitude, givenHeight: CGFloat = .greatestFiniteMagnitude, text: String) -> CGSize {
        let constrainedSize = CGSize(width: givenWidth - insets.left - insets.right, height: givenHeight)
        let attributes = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading,
                                               .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize,
                                                     options: options,
                                                     attributes: attributes,
                                                     context: nil)
        if maxTextWidth < bounds.width {
            return textSize(maxTextWidth, givenWidth: maxTextWidth, text: text)
        } else {
            return CGSize(width: ceil(bounds.width) + insets.right + insets.left,
                          height: ceil(bounds.height) + insets.top + insets.bottom)
        }
    }
    
    deinit {
        print("toast deinit")
    }
}
