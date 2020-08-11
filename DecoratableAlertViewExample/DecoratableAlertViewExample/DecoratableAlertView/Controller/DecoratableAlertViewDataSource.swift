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
    public var timerLimit: Int!
    public var superViewBackgroundColor: UIColor!
    
    fileprivate init(decorator: AlertViewDecoratorProtocol,
                     autoClose: Bool,
                     timerLimit: Int,
                     superViewBackgroundColor: UIColor) {
        self.decorator = decorator
        self.autoClose = autoClose
        self.timerLimit = timerLimit
        self.superViewBackgroundColor = superViewBackgroundColor
    }

    public class Builder {
        
        private var alertDecorator: AlertViewDecoratorProtocol
        private var autoClose: Bool = false
        private var timerLimit: Int = 15
        private var superViewBackgroundColor: UIColor = .clear
        
        public init(alertView: AlertViewProtocol,
                    alertDecorator: AlertViewDecoratorProtocol) {
            self.alertDecorator = alertDecorator
            self.alertDecorator.alertView = alertView
        }
        
        @discardableResult
        public func setAutoCloseDisabled() -> Builder {
            self.autoClose = false
            return self
        }
        
        @discardableResult
        public func setAutoCloseTimeLimit(limit: Int) -> Builder {
            self.autoClose = true
            self.timerLimit = limit
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
            self.alertDecorator.animationTime = animationTime
            return self
        }
        
        @discardableResult
        public func setCanMove(canMove: Bool) -> Builder {
            self.alertDecorator.canMove = canMove
            return self
        }

        public func build() -> DecoratableAlertViewDataSource {
            return DecoratableAlertViewDataSource(decorator: alertDecorator,
                                                  autoClose: autoClose,
                                                  timerLimit: timerLimit,
                                                  superViewBackgroundColor: superViewBackgroundColor)
        }
    }
}
