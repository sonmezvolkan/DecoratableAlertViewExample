//
//  ConstraintModel.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 6.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class ConstraintModel {
    
    public var leadingConstraint: CGFloat?
    public var trailingCosntraint: CGFloat?
    public var topConstraint: CGFloat?
    public var bottomConstraint: CGFloat?
    public var centerXConstraint: CGFloat? = nil
    public var centerYConstraint: CGFloat? = nil
    
    fileprivate init(leadingConstraint: CGFloat?, trailingCosntraint: CGFloat?,
                     topConstraint: CGFloat?, bottomConstraint: CGFloat?,
                     centerXConstraint: CGFloat?, centerYConstraint: CGFloat?) {
        self.leadingConstraint = leadingConstraint
        self.trailingCosntraint = trailingCosntraint
        self.topConstraint = topConstraint
        self.bottomConstraint = bottomConstraint
        self.centerYConstraint = centerYConstraint
        self.centerXConstraint = centerXConstraint
    }
}

extension ConstraintModel {
    
    public class Builder {
        
        public enum BuildStyle: Int {
            case top = 0
            case bottom = 1
            case left = 2
            case right = 3
            case center = 4
        }
        
        private var leadingConstraint: CGFloat? = nil
        private var trailingCosntraint: CGFloat? = nil
        private var topConstraint: CGFloat? = nil
        private var bottomConstraint: CGFloat? = nil
        private var centerXConstraint: CGFloat? = nil
        private var centerYConstraint: CGFloat? = nil
        
        public init() {
            
        }
        
        @discardableResult
        public func setLeadingConstraint(constant: CGFloat) -> Builder {
            self.leadingConstraint = constant
            return self
        }
        
        @discardableResult
        public func setTrailingCosntraint(constant: CGFloat) -> Builder {
            self.trailingCosntraint = constant
            return self
        }
        
        @discardableResult
        public func setTopConstraint(constant: CGFloat) -> Builder {
            self.topConstraint = constant
            return self
        }
        
        @discardableResult
        public func setBottomConstraint(constant: CGFloat) -> Builder {
            self.bottomConstraint = constant
            return self
        }
        
        @discardableResult
        public func setCenterXConstraint(constant: CGFloat) -> Builder {
            self.centerXConstraint = constant
            return self
        }
        
        @discardableResult
        public func setCenterYConstraint(constant: CGFloat) -> Builder {
            self.centerYConstraint = constant
            return self
        }
        
        public func build() -> ConstraintModel {
            return ConstraintModel(leadingConstraint: leadingConstraint,
                                   trailingCosntraint: trailingCosntraint,
                                   topConstraint: topConstraint,
                                   bottomConstraint: bottomConstraint,
                                   centerXConstraint: centerXConstraint,
                                   centerYConstraint: centerYConstraint)
        }
        
        public func build(type: BuildStyle) -> ConstraintModel {
            switch type {
            case .top:
                setConstraintsForTop()
            case .bottom:
                setConstraintsForBottom()
            case .right:
                setConstraintsForRight()
            case .left:
                setConstraintsForLeft()
            case .center:
                setConstraintsForCenter()
            }
            return build()
        }
        
        private func setConstraintsForTop() {
            leadingConstraint = 0
            trailingCosntraint = 0
            topConstraint = 0
        }
        
        private func setConstraintsForBottom() {
            leadingConstraint = 0
            trailingCosntraint = 0
            bottomConstraint = 0
        }
        
        private func setConstraintsForRight() {
            trailingCosntraint = 0
            topConstraint = 0
            bottomConstraint = 0
        }
        
        private func setConstraintsForLeft() {
            leadingConstraint = 0
            topConstraint = 0
            bottomConstraint = 0
        }
        
        private func setConstraintsForCenter() {
            centerXConstraint = 0
            centerYConstraint = 0
        }
    }
}
