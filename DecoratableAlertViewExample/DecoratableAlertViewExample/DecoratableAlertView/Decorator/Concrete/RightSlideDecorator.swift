//
//  RightSlideDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 6.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

//import Foundation
//import UIKit
//
//public class RightSlideDecorator: AlertViewDecoratorProtocol {
//   
//    public var mainView: UIView?
//    
//    public var containerView: UIView?
//    
//    public var alertView: AlertViewProtocol?
//    
//    public var constraintModel: ConstraintModel?
//    
//    public var onClose: (() -> Void)?
//    
//    public var closeTappedAround: Bool = false
//   
//    public var blockUserInteractions: Bool = false
//    
//    public var closeableZoneRatio: CGFloat = 0.3
//    
//    public var touchBeganPosition: CGPoint?
//    
//    public var canMove: Bool = true
//    
//    public var animationTime: TimeInterval = 0.4
//    
//    private var isMoving: Bool = false
//    private var isProcessing: Bool = false
//    
//    public init() {
//        self.canMove = true
//        self.animationTime = 0.4
//    }
//    
//    public init(canMove: Bool = true, animationTime: TimeInterval = 0.4) {
//        self.canMove = canMove
//        self.animationTime = animationTime
//    }
//    
//    public func setConstraints() {
//        guard let mainView = self.mainView, let containerView = self.containerView, let alertView = self.alertView else { return }
//        containerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
//        containerView.backgroundColor = alertView.containerViewBackgroundColor
//        
//        containerView.addSubview(alertView)
//        alertView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let topConstraint: CGFloat = UIDevice.current.hasNotch ? 20 : 0
//        
//        containerView.widthAnchor.constraint(equalToConstant: alertView.size.width).isActive = true
//        alertView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        alertView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        alertView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topConstraint).isActive = true
//        alertView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        
//        containerView.setNeedsLayout()
//        containerView.setNeedsUpdateConstraints()
//        
//        mainView.layoutIfNeeded()
//    }
//    
//    public func openingAnimate() {
//        guard let customView = self.containerView else { return }
//        customView.alpha = 0.0
//        let currentPosition = customView.frame.origin.x
//        customView.frame.origin.x += customView.frame.width
//            
//        UIView.animate(withDuration: animationTime, animations: {
//            customView.alpha = 1.0
//            customView.frame.origin.x = currentPosition
//        })
//    }
//    
//    public func closingAnimate() {
//        guard let customView = self.containerView else { return }
//        isProcessing = true
//        UIView.animate(withDuration: animationTime, animations: {
//            customView.frame.origin.x += customView.frame.width
//            customView.alpha = 0.0
//        }) { [weak self] (_) in
//            self?.containerView = nil
//            self?.onClose?()
//        }
//    }
//    
//    private func checkViewLocation(touch: UITouch) -> Bool {
//        guard let customView = self.containerView, let mainView = self.mainView else { return false}
//        let location = touch.location(in: mainView)
//        
//        if location.x >= customView.frame.origin.x && location.x <= customView.frame.origin.x + customView.frame.width {
//            if location.y >= customView.frame.origin.y && location.y <= customView.frame.origin.y + customView.frame.height {
//                return true
//            }
//        }
//    
//        return false
//    }
//    
//    public func touchesBegan(touches: Set<UITouch>, event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        
//        let touchIsInCustomView = checkViewLocation(touch: touch)
//        if closeTappedAround && !touchIsInCustomView {
//            isProcessing = true
//            closingAnimate()
//        }
//
//        if canMove && touchIsInCustomView {
//            touchBeganPosition = touch.location(in: mainView)
//            isMoving = true
//        }
//    }
//    
//    public func touchesMoved(touches: Set<UITouch>, event: UIEvent?) {
//        guard let customView = self.containerView, let alertView = self.alertView else { return }
//        guard let touch = touches.first else { return }
//        guard let touchBeganPosition = self.touchBeganPosition else { return }
//        guard let mainView = self.mainView else { return }
//        if isProcessing { return }
//        
//        if isMoving && checkViewLocation(touch: touch) {
//            let currentTouchLocation = touch.location(in: mainView)
//            let distanceX = currentTouchLocation.x - touchBeganPosition.x
//            
//            if distanceX >= 0 && distanceX <= (mainView.frame.width - customView.frame.width) {
//                customView.frame.origin.x = mainView.frame.width - customView.frame.width + distanceX
//                
//                if customView.frame.origin.x >= (mainView.frame.width - alertView.frame.width) + (customView.frame.width / 2) {
//                    closingAnimate()
//                }
//            }
//        }
//    }
//    
//    public func touchesEnd(touches: Set<UITouch>, event: UIEvent?) {
//        guard let customView = self.containerView, let touch = touches.first, let mainView = self.mainView,
//            let touchBeganPosition = self.touchBeganPosition, !isProcessing else { return }
//        
//        if checkViewLocation(touch: touch) {
//            let currentTouchLocation = touch.location(in: mainView)
//            let distanceX = currentTouchLocation.x - touchBeganPosition.x
//            
//            if distanceX > customView.frame.width * -closeableZoneRatio {
//                resetCustomViewPosition(customView: customView, mainView: mainView)
//            }
//        } else {
//            resetCustomViewPosition(customView: customView, mainView: mainView)
//        }
//        
//        isMoving = false
//        self.touchBeganPosition = nil
//    }
//    
//    private func resetCustomViewPosition(customView: UIView, mainView: UIView) {
//        guard let mainView = self.mainView else { return }
//        isProcessing = true
//        UIView.animate(withDuration: animationTime / 2, animations: {
//            customView.frame.origin.x = mainView.frame.width - customView.frame.width
//        }, completion: { [weak self] _ in
//            self?.isProcessing = false
//        })
//    }
//}
