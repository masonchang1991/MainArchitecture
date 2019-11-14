//
//  HUDPresenter.swift
//  HanFans
//
//  Created by Mason on 2019/7/30.
//  Copyright © 2019 han. All rights reserved.
//

import Foundation
import UIKit

enum HUDStyle {
    case toast
    case indicator
}

protocol HUDObject: UIView, HUDPresenter {
    var hudId: String { get }
    var hudDescription: String { get set }
    var style: HUDStyle { get }
}

protocol HUDPresenter: Loggable {
    var showAnimation: UIViewPropertyAnimator? { get set }
    var moveAnimation: UIViewPropertyAnimator? { get set }
    var dismissAnimation: UIViewPropertyAnimator? { get set }
    
    @discardableResult
    mutating func show(_ completion: @escaping ((HUDPresenter?) -> ())) -> Self
    @discardableResult
    mutating func dismiss(immediately: Bool, _ completion: @escaping ((HUDPresenter?) -> ())) -> Self
    @discardableResult
    mutating func move(to: CGRect) -> Self
}

extension HUDPresenter where Self: UIView {
    
    var visibleVC: UIViewController? {
        let appCoordinator = AppDelegate.shared.appCoordinator!
        return appCoordinator.topCoordinator.router.toPresent()
    }
    
    @discardableResult
    mutating func show(_ completion: @escaping ((HUDPresenter?) -> ())) -> Self {
        if showAnimation != nil { return self }
        
        alpha = 0.69
        visibleVC?.view.addSubview(self)
        let animation = UIViewPropertyAnimator(duration: 3.0, curve: .easeInOut) { [weak self] in
            self?.alpha = 1
        }
        showAnimation = animation
        showAnimation?.addCompletion({ [weak self] (position) in
            self?.dismiss(completion)
        })
        showAnimation?.startAnimation()
        
        return self
    }
    
    @discardableResult
    mutating func dismiss(immediately: Bool = false, _ completion: @escaping ((HUDPresenter?) -> ())) -> Self {
        self.showAnimation?.stopAnimation(true)
        let animation = UIViewPropertyAnimator(duration: immediately ? 0.01 : 1.0, curve: .linear) { [weak self] in
            self?.alpha = 0
        }
        self.dismissAnimation = animation
        self.dismissAnimation?.addCompletion({ [weak self](position) in
            self?.removeFromSuperview()
            completion(self)
        })
        self.dismissAnimation?.startAnimation()
        
        return self
    }
    
    @discardableResult
    mutating func move(to: CGRect) -> Self {
        if moveAnimation != nil {
            let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) { [weak self] in
                self?.frame = to
            }
            self.moveAnimation = animation
            self.moveAnimation?.startAnimation()
        } else {
            let animation = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut) { [weak self] in
                self?.frame = to
            }
            moveAnimation = animation
            moveAnimation?.startAnimation()
        }
        
        return self
    }
}

class GMHUDHandler: Loggable {
    
    enum PresentStyle {
        case pushUp(count: Int)
        case stack(count: Int)
        case cover
    }
    
    static let shared = GMHUDHandler()
    var presentStyle: PresentStyle = .pushUp(count: 4)
    
    private var toasts: [HUDToast] = []
    private var needDumpToasts: [HUDToast] = []
    
    func show(_ object: HUDObject) {
        switch object.style {
        case .toast:
            guard let toast = object as? HUDToast else { return }
            toasts.insert(toast, at: 0)
            showToast(toast)
        case .indicator:
            
            break
        }
    }
    
    private func showToast(_ toast: HUDToast) {
        switch presentStyle {
        case .pushUp(let count):
            cleanDumpList()
            pushUp(maxCount: count)
        case .stack(let count):
            cleanDumpList()
            stack(maxCount: count)
        case .cover:
            
            break
        }
    }
    
    private func stack(maxCount: Int) {
        //MARK: - 起始距離邊緣距離
        let originDistance: CGFloat = 100.0
        
        toasts.first?.frame.origin = CGPoint(x: (UIScreen.width - (toasts.first?.bounds.width ?? 0.0)) / 2,
                                             y: UIScreen.height -  1)
        for (index, var toast) in toasts.enumerated() {
            if index < maxCount {
                let toastTopToEdgeDistance = originDistance + toast.bounds.height
                let toOrigin = CGPoint(x: (UIScreen.width - toast.bounds.width) / 2,
                                       y: UIScreen.height - toastTopToEdgeDistance)
                let toFrame = CGRect(origin: toOrigin, size: toast.frame.size)
                toast.show { [weak self] (toast) in
                    guard
                        let self = self,
                        let toast = toast as? HUDToast else { return }
                    self.needDumpToasts.append(toast)
                }
                toast.move(to: toFrame)
            } else {
                toast.dismiss(immediately: true) { [weak self] (toast) in
                    guard
                        let self = self,
                        let toast = toast as? HUDToast else { return }
                    self.needDumpToasts.append(toast)
                }
            }
        }
    }
    
    private func pushUp(maxCount: Int) {
        //MARK: - 起始距離邊緣距離
        let originDistance: CGFloat = 100.0
        //MARK: - toasts 間距
        let toastSpacing: CGFloat = 5.0
        //MARK: - toast 頂距離螢幕邊緣距離
        var toastTopToEdgeDistance: CGFloat = originDistance
        
        toasts.first?.frame.origin = CGPoint(x: (UIScreen.width - (toasts.first?.bounds.width ?? 0.0)) / 2,
                                             y: UIScreen.height -  1)
        for (index, var toast) in toasts.enumerated() {
            if index < maxCount {
                toastTopToEdgeDistance += toastSpacing
                toastTopToEdgeDistance += toast.bounds.height
                let toOrigin = CGPoint(x: (UIScreen.width - toast.bounds.width) / 2,
                                       y: UIScreen.height - toastTopToEdgeDistance)
                let toFrame = CGRect(origin: toOrigin, size: toast.frame.size)
                toast.show { [weak self] (toast) in
                    guard
                        let self = self,
                        let toast = toast as? HUDToast else { return }
                    self.needDumpToasts.append(toast)
                }
                toast.move(to: toFrame)
            } else {
                toast.dismiss(immediately: true) { [weak self] (toast) in
                    guard
                        let self = self,
                        let toast = toast as? HUDToast else { return }
                    self.needDumpToasts.append(toast)
                }
            }
        }
    }
    
    private func cleanDumpList() {
        for dumpToast in needDumpToasts {
            for (index, toast) in toasts.enumerated().reversed() {
                if dumpToast === toast { toasts.remove(at: index) }
            }
        }
        needDumpToasts.removeAll()
    }
}

