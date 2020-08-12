//
//  LeftSlideDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 6.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class LeftSlideDecorator: AlertViewDecoratorProtocol {
    
    public var mainView: UIView?
    
    public var containerView = UIView()
    
    public var shadowView: UIView?
    
    public var alertView: AlertViewProtocol?
    
    public var constraintModel: ConstraintModel?
    
    public var animationModel: AnimationModel?
    
    public var createDefaultAnimationModel: (() -> AnimationModel)?
    
    public var onClose: (() -> Void)?
    
    public var closeTappedAround: Bool = false
    
    public var blockUserInteractions: Bool = false
    
    public var closeableZoneRatio: CGFloat = 0.3
    
    public var touchBeganPosition: CGPoint?
    
    public var canMove: Bool = true
    
    public var shadowViewAlphaValue: CGFloat = 0.4
    
    private var isInAnimating: Bool = true
    
    public init() {
        
    }
    
    public func setConstraints() {
        let constraints = ConstraintModel.Builder()
            .setLeadingConstraint(constant: 0)
            .setBottomConstraint(constant: 0)
            .setTopConstraint(constant: 0)
            .build()
        
        setConstraints(constraintModel: constraints, selector: #selector(tappedAround))
        addPanGestureRecognizerIfNeeded()
    }
    
    @objc private func tappedAround() {
        if !closeTappedAround { return }
        closingAnimate()
    }
    
    public func openingAnimate() {
        self.containerView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        UIView.animate(withDuration: getAnimationModel().animationTime, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { isFinished in
            self.isInAnimating = false
        })
    }
    
    public func closingAnimate() {
        isInAnimating = true
        UIView.animate(withDuration: getAnimationModel().animationTime, animations: {
            self.containerView.transform = CGAffineTransform(translationX: -self.containerView.frame.width, y: 0)
            self.shadowView?.alpha = 0
        }, completion: { isFinished in
            self.containerView.removeFromSuperview()
            self.shadowView?.removeFromSuperview()
            self.isInAnimating = false
        })
    }
    
    private func addPanGestureRecognizerIfNeeded() {
        if !canMove { return }
        
        alertView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(panGesture:))))
    }
    
    @objc private func handlePan(panGesture: UIPanGestureRecognizer) {
        guard let mainView = self.mainView, !isInAnimating else { return }
        if panGesture.state == .began || panGesture.state == .changed {
            let translation = panGesture.translation(in: self.mainView)
            if translation.x > 0 { return }
            
            containerView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
            if -translation.x >= containerView.frame.width * closeableZoneRatio {
                closingAnimate()
            }
            
        } else if panGesture.state == .ended {
            if checkVelocity(velocity: panGesture.velocity(in: mainView)) {
                return
            }
            
            handlePanEnd()
        }
    }
    
    private func handlePanEnd() {
        if containerView.frame.origin.x == 0 { return }
        isInAnimating = true
        UIView.animate(withDuration: getAnimationModel().animationTime / 2, animations: {
            self.containerView.transform = .identity
        }, completion: { isFinished in
            self.isInAnimating = false
        })
    }
    
    private func checkVelocity(velocity: CGPoint) -> Bool {
        print(velocity.x)
        if velocity.x > -600 { return false }
        getAnimationModel().animationTime /= 2
        closingAnimate()
        return true
    }
}
