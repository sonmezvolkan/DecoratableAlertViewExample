//
//  RightSlideDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 6.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class RightSlideDecorator: AlertViewDecoratorProtocol {
    
    public var mainView: UIView?
    
    public var containerView = UIView()
    
    public var shadowView: UIView?
    
    public var alertView: AlertViewProtocol?
    
    public var constraintModel: ConstraintModel?
    
    public var onClose: (() -> Void)?
    
    public var closeTappedAround: Bool = false
    
    public var blockUserInteractions: Bool = false
    
    public var closeableZoneRatio: CGFloat = 0.3
    
    public var touchBeganPosition: CGPoint?
    
    public var canMove: Bool = true
    
    public var animationTime: TimeInterval = 0.4
    
    public var shadowViewAlphaValue: CGFloat = 0.4
    
    private var isInAnimating: Bool = true
    
    public init() {
        self.canMove = true
        self.animationTime = 0.4
    }
    
    public init(canMove: Bool = true, animationTime: TimeInterval = 0.4) {
        self.canMove = canMove
        self.animationTime = animationTime
    }
    
    public func setConstraints() {
        guard let mainView = self.mainView, let alertView = self.alertView else { return }
        addShadowViewIfNeeded()
        mainView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        containerView.backgroundColor = alertView.containerViewBackgroundColor
        
        containerView.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        alertView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        alertView.resizeView()
        addPanGestureRecognizerIfNeeded()
        
        mainView.layoutIfNeeded()
    }
    
    private func addShadowViewIfNeeded() {
        guard let mainView = self.mainView, blockUserInteractions else { return }
        shadowView = UIView()
        shadowView!.frame = mainView.frame
        if shadowViewAlphaValue > 0 {
            shadowView!.backgroundColor = .black
            shadowView!.alpha = shadowViewAlphaValue
        } else {
            shadowView?.backgroundColor = .clear
        }
        shadowView!.isUserInteractionEnabled = true
        shadowView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedAround)))
        mainView.addSubview(shadowView!)
    }
    
    @objc private func tappedAround() {
        if !closeTappedAround { return }
        closingAnimate()
    }
    
    public func openingAnimate() {
        self.containerView.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
        UIView.animate(withDuration: animationTime, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { isFinished in
            self.isInAnimating = false
        })
    }
    
    public func closingAnimate() {
        isInAnimating = true
        UIView.animate(withDuration: animationTime, animations: {
            self.containerView.transform = CGAffineTransform(translationX: self.containerView.frame.width, y: 0)
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
            print(translation.x)
            if translation.x < 0 { return }
            
            containerView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
            if translation.x >= containerView.frame.width * closeableZoneRatio {
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
        UIView.animate(withDuration: animationTime / 2, animations: {
            self.containerView.transform = .identity
        }, completion: { isFinished in
            self.isInAnimating = false
        })
    }
    
    private func checkVelocity(velocity: CGPoint) -> Bool {
        print(velocity.x)
        if velocity.x < 600 { return false }
        animationTime /= 2
        closingAnimate()
        return true
    }
    
}
