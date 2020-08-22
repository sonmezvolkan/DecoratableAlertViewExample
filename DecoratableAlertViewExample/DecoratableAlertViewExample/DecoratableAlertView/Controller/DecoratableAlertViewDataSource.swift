//
//  DecoratableAlertViewDataSource.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 7.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class DecoratableAlertViewDataSource {
    
    public let decorator: AlertViewDecoratorProtocol!
    public let autoClose: Bool!
    public var duration: Int!
    public var superViewBackgroundColor: UIColor!
    
    fileprivate init(decorator: AlertViewDecoratorProtocol,
                     autoClose: Bool,
                     duration: Int,
                     superViewBackgroundColor: UIColor) {
        self.decorator = decorator
        self.autoClose = autoClose
        self.duration = duration
        self.superViewBackgroundColor = superViewBackgroundColor
    }

    public class Builder {
        
        private var alertDecorator: AlertViewDecoratorProtocol
        private var autoClose: Bool = false
        private var duration: Int = 15
        private var superViewBackgroundColor: UIColor = .clear
        
        public init(alertView: AlertViewProtocol,
                    alertDecorator: AlertViewDecoratorProtocol) {
            self.alertDecorator = alertDecorator
            self.alertDecorator.alertView = alertView
            
            self.alertDecorator.createAnimationModelInstance()
        }
        
        internal init(alertView: AlertViewProtocol,
                    alertDecorator: AlertViewDecoratorProtocol,
                    withDefaultAnimationInstance: Bool) {
            self.alertDecorator = alertDecorator
            self.alertDecorator.alertView = alertView
            
            if withDefaultAnimationInstance {
                self.alertDecorator.createAnimationModelInstance()
            }
        }
        
        @discardableResult
        public func setAutoCloseEnabled(enabled: Bool) -> Builder {
            self.autoClose = enabled
            return self
        }
        
        @discardableResult
        public func setDuration(duration: Int) -> Builder {
            self.autoClose = true
            self.duration = duration
            return self
        }
        
        @discardableResult
        public func setCloseTappedAround(isEnabled: Bool) -> Builder {
            self.alertDecorator.closeTappedAround = isEnabled
            return self
        }
        
        @discardableResult
        public func setBlockUserInteractions(isEnabled: Bool) -> Builder {
            self.alertDecorator.blockUserInteractions = isEnabled
            return self
        }
        
        @discardableResult
        public func setShadowViewAlphaValue(value: CGFloat) -> Builder {
            self.alertDecorator.shadowViewAlphaValue = value
            return self
        }

        @discardableResult
        public func setClosableZoneRatio(ratio: CGFloat) -> Builder {
            if ratio <= 0 || ratio > 1 { fatalError("Ratio can not be 0 and higher than 1") }
            self.alertDecorator.closeableZoneRatio = ratio
            return self
        }
        
        @discardableResult
        public func setSuperViewBackgroundColor(color: UIColor) -> Builder {
            self.superViewBackgroundColor = color
            return self
        }
        
        @discardableResult
        public func setAnimationTime(animationTime: TimeInterval) -> Builder {
            self.alertDecorator.animationModel?.animationTime = animationTime
            return self
        }
        
        @discardableResult
        public func setAnimationDelay(delay: TimeInterval) -> Builder {
            self.alertDecorator.animationModel?.delay = delay
            return self
        }
        
        @discardableResult
        public func setUsingSpringWithDamping(ratio: CGFloat) -> Builder {
            self.alertDecorator.animationModel?.usingSpringWithDamping = ratio
            return self
        }
        
        @discardableResult
        public func setInitialSpringVelocity(value: CGFloat) -> Builder {
            self.alertDecorator.animationModel?.initialSpringVelocity = value
            return self
        }
        
        @discardableResult
        public func setAnimationOptions(options: UIView.AnimationOptions) -> Builder {
            self.alertDecorator.animationModel?.options = options
            return self
        }
        
        
        @discardableResult
        public func setCanMove(canMove: Bool) -> Builder {
            self.alertDecorator.canMove = canMove
            return self
        }

        public func getDataSource() -> DecoratableAlertViewDataSource {
            return DecoratableAlertViewDataSource(decorator: alertDecorator,
                                                  autoClose: autoClose,
                                                  duration: duration,
                                                  superViewBackgroundColor: superViewBackgroundColor)
        }
        
        public func show() {
            guard let controller = UIApplication.getTopMostViewController() else { return }
            
            controller.showDecoratableAlertView(dataSource: getDataSource())
        }
    }
}
