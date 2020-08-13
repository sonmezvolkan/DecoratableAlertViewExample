//
//  AlertViewDecoratorProtocol.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public protocol AlertViewDecoratorProtocol: class {
    
    var mainView: UIView? { get set }
    
    var containerView: UIView { get set }
    
    var shadowView: UIView? { get set }
    
    var alertView: AlertViewProtocol? { get set }
    
    var constraintModel: ConstraintModel? { get set }

    var createDefaultAnimationModel: (() -> AnimationModel)? { get set }
    
    var animationModel: AnimationModel? { get set }
    
    var onClose: (() -> Void)? { get set }
    
    var canMove: Bool { get set }
    
    var blockUserInteractions: Bool { get set }
    
    var closeTappedAround: Bool { get set }
    
    var closeableZoneRatio: CGFloat { get set }
    
    var shadowViewAlphaValue: CGFloat { get set }
    
    func setConstraints()
    
    func openingAnimate()
    
    func closingAnimate()
    
}

extension AlertViewDecoratorProtocol {
    
    public func getAnimationModel() -> AnimationModel {
        if animationModel == nil {
            animationModel = AnimationModel()
        }
        
        return animationModel!
    }
    
    public func createAnimationModelInstance() {
        if let createDefaultAnimation = self.createDefaultAnimationModel {
            self.animationModel = createDefaultAnimation()
        } else {
            self.animationModel = AnimationModel()
        }
    }
}

extension AlertViewDecoratorProtocol {
    
    public func removeViews() {
        self.containerView.removeFromSuperview()
        self.shadowView?.removeFromSuperview()
    }
}

extension AlertViewDecoratorProtocol {
    
    public func setConstraints(constraintModel: ConstraintModel, selector: Selector? = nil) {
        
        guard let mainView = self.mainView else { return }
        addShadowViewIfNeeded(selector: selector)
        mainView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = constraintModel.leadingConstraint {
            containerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,
                                                   constant: leading).isActive = true
        }
        
        if let trailing = constraintModel.trailingCosntraint {
            containerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,
                                                    constant: -trailing).isActive = true
        }
        
        var topConstantForAlertView: CGFloat = UIDevice.current.hasNotch ? 20 : 0
        if let top = constraintModel.topConstraint {
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor,
                constant: top).isActive = true
            if top > 0 {
                topConstantForAlertView = 0
            }
        }
        
        if let bottom = constraintModel.bottomConstraint {
            containerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor,
                                                    constant: bottom).isActive = true
        }
        
        if let centerX = constraintModel.centerXConstraint {
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: centerX).isActive = true
        }
        
        if let centerY = constraintModel.centerYConstraint {
            containerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: centerY).isActive = true
        }
        
        addAlertView(topConstant: topConstantForAlertView)
    }
    
    private func addAlertView(topConstant: CGFloat) {
        guard let mainView = self.mainView, let alertView = self.alertView else { return }
        
        containerView.backgroundColor = alertView.containerViewBackgroundColor
        containerView.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topConstant).isActive = true
        alertView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        alertView.resizeView()
        
        mainView.layoutIfNeeded()
    }
    
    private func addShadowViewIfNeeded(selector: Selector?) {
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
        shadowView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        mainView.addSubview(shadowView!)
    }
}
