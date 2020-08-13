//
//  TopScalingDecorator.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 10.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class ScalingDecorator: AlertViewDecoratorProtocol {
    
    public var mainView: UIView?
    
    public var containerView = UIView()
    
    public var shadowView: UIView?
    
    public var alertView: AlertViewProtocol?
    
    public var constraintModel: ConstraintModel?
    
    public var animationModel: AnimationModel?
    
    public var createDefaultAnimationModel: (() -> AnimationModel)? = {
        let animationModel = AnimationModel()
        animationModel.initialSpringVelocity = 1
        animationModel.usingSpringWithDamping = 0.5
        animationModel.options = .curveEaseInOut
        return animationModel
    }
    
    public var onClose: (() -> Void)?
    
    public var closeTappedAround: Bool = false
    
    public var blockUserInteractions: Bool = false
    
    public var closeableZoneRatio: CGFloat = 0.3
    
    public var touchBeganPosition: CGPoint?
    
    public var canMove: Bool = true
    
    public var shadowViewAlphaValue: CGFloat = 0.4
    
    private var isAnimating: Bool = true
    
    public init() {
        self.constraintModel = ConstraintModel.Builder().build(type: .top)
    }
    
    public init(type: ConstraintModel.Builder.BuildStyle) {
        self.constraintModel = ConstraintModel.Builder().build(type: type)
    }
    
    public init(constraints: ConstraintModel) {
        self.constraintModel = constraints
    }
    
    public func setConstraints() {
        guard let constraints = self.constraintModel else { return }
        
        setConstraints(constraintModel: constraints, selector: #selector(tappedAround))
    }
    
    @objc private func tappedAround() {
        if !closeTappedAround { return }
        closingAnimate()
    }
    
    public func openingAnimate() {
        self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        UIView.animate(withDuration: getAnimationModel().animationTime,
                       delay: getAnimationModel().delay,
                       usingSpringWithDamping: getAnimationModel().usingSpringWithDamping,
                       initialSpringVelocity: getAnimationModel().initialSpringVelocity,
                       options: getAnimationModel().options, animations: {
            self.containerView.transform = .identity
        }, completion: { isFinished in
            self.isAnimating = false
        })
    }
    
    public func closingAnimate() {
        if isAnimating { return }
        UIView.animate(withDuration: getAnimationModel().animationTime, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: { isFinished in
            self.removeViews()
        })
    }
}
