//
//  DefaultAlertView+Animation.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 21.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

extension DefaultAlertView.Builder {
    
    internal func openingAnimation() {
        setOpeningTransform()
        alertDecorator.shadowView?.alpha = 0
        
        let animation = alertDecorator.getAnimationModel()

        UIView.animate(withDuration: animation.animationTime,
                       delay: animation.delay,
                       usingSpringWithDamping: animation.usingSpringWithDamping,
                       initialSpringVelocity: animation.initialSpringVelocity,
                       options: animation.options,
                       animations: {
            self.alertDecorator.containerView.transform = .identity
            self.alertDecorator.shadowView?.alpha = self.alertDecorator.shadowViewAlphaValue
            if self.openingAnimateType == .fadeIn || self.fadeInEnabled {
                self.alertDecorator.containerView.alpha = 1.0
            }
        })
    }
    
    internal func closingAnimation() {
        let transform = getClosingTransform()
        UIView.animate(withDuration: alertDecorator.getAnimationModel().animationTime, animations: {
            if let transform = transform {
                self.alertDecorator.containerView.transform = transform
            }
            self.alertDecorator.shadowView?.alpha = 0
            if self.openingAnimateType == .fadeIn || self.fadeInEnabled {
                self.alertDecorator.containerView.alpha = 0
            }
        }, completion: { isFinished in
            self.alertDecorator.removeViews()
        })
    }
    
    private func setOpeningTransform() {
        switch openingAnimateType {
        case .fromTop:
            alertDecorator.containerView.transform = CGAffineTransform(translationX: 0, y: -600)
        case .fromBottom:
            alertDecorator.containerView.transform = CGAffineTransform(translationX: 0, y: 600)
        case .fromRight:
            alertDecorator.containerView.transform = CGAffineTransform(translationX: 400, y: 0)
        case .fromLeft:
            alertDecorator.containerView.transform = CGAffineTransform(translationX: -400, y: 0)
        case .fadeIn:
            alertDecorator.containerView.alpha = 0
        }
    }
    
    private func getClosingTransform() -> CGAffineTransform? {
        switch closingAnimateType {
        case .toTop:
            return CGAffineTransform(translationX: 0, y: -600)
        case .toBottom:
            return CGAffineTransform(translationX: 0, y: 600)
        case .toRight:
            return CGAffineTransform(translationX: 400, y: 0)
        case .toLeft:
            return CGAffineTransform(translationX: -400, y: 0)
        case .fadeOut:
            return nil
        }
    }
}
