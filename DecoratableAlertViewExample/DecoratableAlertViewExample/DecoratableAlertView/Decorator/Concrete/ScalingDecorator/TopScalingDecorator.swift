//
//  TopScalingDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 10.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class TopScalingDecorator: AlertViewDecoratorProtocol {
    
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
    
    private var isAnimating: Bool = true
    
    private var topConstraint: NSLayoutConstraint?
    
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
        containerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        self.topConstraint = containerView.topAnchor.constraint(equalTo: mainView.topAnchor)
        self.topConstraint?.isActive = true
        
        containerView.backgroundColor = alertView.containerViewBackgroundColor
        
        containerView.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint: CGFloat = UIDevice.current.hasNotch ? 20 : 0
        
        alertView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topConstraint).isActive = true
        alertView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        alertView.resizeView()
        
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
        self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: animationTime, animations: {
            self.containerView.transform = .identity
        }, completion: { (isFinished) in
            self.isAnimating = false
        })
    }
    
    public func closingAnimate() {
        if isAnimating { return }
        UIView.animate(withDuration: animationTime, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: { isFinished in
            self.containerView.removeFromSuperview()
            self.shadowView?.removeFromSuperview()
        })
    }
}
