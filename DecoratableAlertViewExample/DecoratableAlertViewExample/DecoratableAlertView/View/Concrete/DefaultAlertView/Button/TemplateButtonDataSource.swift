//
//  TemplateButtonDataSource.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 21.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class TemplateButtonDataSource {
    
    public var title: String
    public var onDidTap: (() -> Void)
    public var buttonBackgroundColor: UIColor
    public var buttonFont: UIFont?
    public var buttonTextColor: UIColor
    public var buttonRadius: CGFloat
    
    fileprivate init(title: String,
                     onDidTap: @escaping (() -> Void),
                     buttonBackgroundColor: UIColor,
                     buttonFont: UIFont?,
                     buttonTextColor: UIColor,
                     buttonRadius: CGFloat) {
        self.title = title
        self.onDidTap = onDidTap
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonFont = buttonFont
        self.buttonTextColor = buttonTextColor
        self.buttonRadius = buttonRadius
    }
}

extension TemplateButtonDataSource {
    
    public class Builder {
        private var title: String
        private var onDidTap: (() -> Void)
        private var backgroundColor: UIColor = .systemPink
        private var font: UIFont?
        private var textColor: UIColor = .white
        private var radius: CGFloat = 16
        
        public init(title: String, onDidTap: @escaping (() -> Void)) {
            self.title = title
            self.onDidTap = onDidTap
        }
        
        @discardableResult
        public func setBackgroudColor(backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        @discardableResult
        public func setFont(font: UIFont) -> Builder {
            self.font = font
            return self
        }
        
        @discardableResult
        public func setTextColor(color: UIColor) -> Builder {
            self.textColor = color
            return self
        }
        
        @discardableResult
        public func setRadius(radius: CGFloat) -> Builder {
            self.radius = radius
            return self
        }
        
        public func build() -> TemplateButtonDataSource {
            return TemplateButtonDataSource(title: title,
                                            onDidTap: onDidTap,
                                            buttonBackgroundColor: backgroundColor,
                                            buttonFont: font,
                                            buttonTextColor: textColor,
                                            buttonRadius: radius)
        }
    }
}
