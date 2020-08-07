//
//  FadeInDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 6.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class FadeInDecorator: AlertViewDecoratorProtocol {

    public var mainView: UIView?
    
    public var containerView: UIView?
    
    public var alertView: AlertViewProtocol?
    
    public var constraintModel: ConstraintModel?
    
    public var onClose: (() -> Void)?
    
    public var closeTappedAround: Bool = true
    
    public var closeableZoneRatio: CGFloat = 0.3
    
    public var touchBeganPosition: CGPoint?
    
    public var canMove: Bool = true
    
    public var animationTime: TimeInterval = 0.4
    
    private var isMoving: Bool = false
    private var isProcessing: Bool = false
    
    public init() {
        self.canMove = true
        self.animationTime = 0.4
    }
    
    public init(canMove: Bool = true, animationTime: TimeInterval = 0.4) {
        self.canMove = canMove
        self.animationTime = animationTime
    }
    
    public func setConstraints() {
        guard let mainView = self.mainView, let containerView = self.containerView, let alertView = self.alertView else { return }
        containerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: constraintModel?.leadingConstraint ?? 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -1 * (constraintModel?.trailingCosntraint ?? 0)).isActive = true
        containerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: constraintModel?.topConstraint ?? 0).isActive = true
        containerView.backgroundColor = alertView.containerViewBackgroundColor
        
        containerView.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false

        
        containerView.heightAnchor.constraint(equalToConstant: alertView.size.height).isActive = true
        alertView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        alertView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.setNeedsLayout()
        containerView.setNeedsUpdateConstraints()
        
        mainView.layoutIfNeeded()
    }
    
    public func openingAnimate() {
        guard let customView = self.containerView else { return }
        customView.alpha = 0.0
            
        UIView.animate(withDuration: animationTime, animations: {
            customView.alpha = 1.0
        })
    }
    
    public func closingAnimate() {
        guard let customView = self.containerView else { return }
        isProcessing = true
        UIView.animate(withDuration: animationTime, animations: {
            customView.alpha = 0.0
        }) { [weak self] (_) in
            self?.containerView = nil
            self?.onClose?()
        }
    }
    
    public func touchesBegan(touches: Set<UITouch>, event: UIEvent?) {
    }
    
    public func touchesMoved(touches: Set<UITouch>, event: UIEvent?) {
    }
    
    public func touchesEnd(touches: Set<UITouch>, event: UIEvent?) {
    }
}
