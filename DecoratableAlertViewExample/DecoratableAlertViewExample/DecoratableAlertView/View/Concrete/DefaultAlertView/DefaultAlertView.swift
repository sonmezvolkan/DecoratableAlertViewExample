//
//  DefaultAlertView.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 13.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class DefaultAlertView: UIView, AlertViewProtocol {
    
    public var onClose: (() -> Void)?
    
    public var containerViewBackgroundColor: UIColor?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var title: String?
    private var message: String?
    private var buttons: [UIButton]?
    private var axis: NSLayoutConstraint.Axis = .horizontal
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    fileprivate init(title: String?, message: String,
                     buttons: [UIButton], axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        self.title = title
        self.message = message
        self.buttons = buttons
        self.axis = axis
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("DefaultAlertView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .red
        addSubview(contentView)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 72).isActive = true 
        
        setContents()
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentView.systemLayoutSizeFitting(self.bounds.size)
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setContents() {
        lblTitle.text = title
        lblDescription.text = message
        
        addButtonsIfNeeded()
    }
    
    private func addButtonsIfNeeded() {
        guard let buttons = self.buttons else { return }
        
        stackView.axis = axis
        
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
    }
}

extension DefaultAlertView {
    
    public class Builder {
        
        private var title: String?
        private var message: String
        private var buttons: [UIButton] = []
        private var axis: NSLayoutConstraint.Axis = .horizontal
        
        public init(message: String) {
            self.message = message
        }
        
        public init(title: String, message: String) {
            self.title = title
            self.message = message
        }
        
        @discardableResult
        public func setTitle(title: String) -> Builder {
            self.title = title
            return self
        }
        
        @discardableResult
        public func setDirection(axis: NSLayoutConstraint.Axis) -> Builder {
            self.axis = axis
            return self
        }
        
        @discardableResult
        public func addButton(button: UIButton) -> Builder {
            self.buttons.append(button)
            return self
        }
        
        public func build() -> DefaultAlertView {
            return DefaultAlertView(title: title,
                                    message: message,
                                    buttons: buttons,
                                    axis: axis)
        }
    }
}
