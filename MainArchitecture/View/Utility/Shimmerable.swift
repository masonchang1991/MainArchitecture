//
//  Shimmerable.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import UIKit

enum ShimmerSection {
    case this
    case subviews
    case all
}

protocol Shimmerable: UIView {
    var isShimmerAnimating: Bool { get set }
    var maskGradientLayer: CAGradientLayer? { get set }
    var shimmerBackView: UIView? { get set }
    var shimmerView: UIView? { get set }
    func startShimmer(include section: ShimmerSection)
    func removeShimmer(include section: ShimmerSection)
    //set in layout subView
    func shimmerLayerFrameUpdate()
}

extension UIView {
    struct AnimationKey {
        static let shimmer = "shimmer"
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap({ $0.subviewsRecursive() })
    }
}

extension Shimmerable {
    
    private func getAllShimmerSubViews() -> [Shimmerable] {
        var shimmerViews: [Shimmerable] = []
        for subView in subviewsRecursive() {
            if let shimmerView = subView as? Shimmerable {
                shimmerViews.append(shimmerView)
            }
        }
        return shimmerViews
    }
    
    private func setShimmerViewIfNeeded() {
        if shimmerBackView == nil {
            let shimmerBackView = UIView(frame: bounds)
            addSubview(shimmerBackView)
            shimmerBackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.shimmerBackView = shimmerBackView
            self.shimmerBackView?.backgroundColor = UIColor(hex: 0xF7F7F7)
        }
        
        if shimmerView == nil {
            let shimmerView = UIView(frame: bounds)
            shimmerBackView?.addSubview(shimmerView)
            shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.shimmerView = shimmerView
            self.shimmerView?.backgroundColor = UIColor(hex: 0xDFE3EE)
        }
    }
    
    private func createAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.8
        animation.fromValue = -frame.size.width
        animation.toValue = frame.size.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func shimmerLayerFrameUpdate() {
        maskGradientLayer?.frame = bounds
        let animationKey = AnimationKey.shimmer
        maskGradientLayer?.removeAnimation(forKey: animationKey)
        maskGradientLayer?.add(createAnimation(), forKey: animationKey)
    }
    
    func startShimmer(include section: ShimmerSection) {
        switch section {
        case .all: fallthrough
        case .this:
            if isShimmerAnimating { return }
            self.isShimmerAnimating = true
            setShimmerViewIfNeeded()
            shimmerBackView?.isHidden = false
            shimmerView?.isHidden = false
            clipsToBounds = true
            if let maskGradientLayer = self.maskGradientLayer {
                maskGradientLayer.add(createAnimation(), forKey: AnimationKey.shimmer)
            } else {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [UIColor.clear.cgColor,
                                        UIColor.white.withAlphaComponent(0.8).cgColor,
                                        UIColor.clear.cgColor]
                gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
                gradientLayer.frame = bounds
                shimmerView?.layer.mask = gradientLayer
                gradientLayer.add(createAnimation(), forKey: AnimationKey.shimmer)
                maskGradientLayer = gradientLayer
            }
            
            if section == .all { fallthrough }
        case .subviews:
            for shimmerView in getAllShimmerSubViews() {
                shimmerView.startShimmer(include: .this)
            }
        }
    }
    
    func removeShimmer(include section: ShimmerSection) {
        switch section {
        case .all: fallthrough
        case .this:
            maskGradientLayer?.removeAllAnimations()
            maskGradientLayer = nil
            shimmerView?.layer.mask = nil
            shimmerView?.removeFromSuperview()
            shimmerView = nil
            shimmerBackView?.removeFromSuperview()
            shimmerBackView = nil
            isShimmerAnimating = false
            
            if section == .all { fallthrough }
        case .subviews:
            for shimmerView in getAllShimmerSubViews() {
                shimmerView.removeShimmer(include: .this)
            }
        }
    }
}

class ShimmerableImageView: UIImageView, Shimmerable {
    var isShimmerAnimating: Bool = false
    var shimmerView: UIView?
    var shimmerBackView: UIView?
    var maskGradientLayer: CAGradientLayer? = nil
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmerLayerFrameUpdate()
    }
}
