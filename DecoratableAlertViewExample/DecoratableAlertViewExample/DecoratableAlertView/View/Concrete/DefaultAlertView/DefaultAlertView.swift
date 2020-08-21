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
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblMessageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var dataSource: DefaultAlertViewDataSource
    
    private var TOP_CONSTRAINT_WITH_IMAGE: CGFloat = 112
    
    fileprivate init(dataSource: DefaultAlertViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        
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

        setContents()
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentView.systemLayoutSizeFitting(self.bounds.size)
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setContents() {
        setComponents()
        setViewWidth()
        setTopOfAlertView()
        lblMessage.text = dataSource.message
        addButtonsIfNeeded()
    }
    
    private func setViewWidth() {
        contentView.widthAnchor.constraint(equalToConstant: dataSource.width).isActive = true
    }
    
    private func setTopOfAlertView() {
        let isImageExist = self.dataSource.image != nil
        
        lblTitle.isHidden = isImageExist
        imageView.isHidden = !isImageExist
        
        if isImageExist {
            imageView.image = self.dataSource.image
            lblMessageTopConstraint.constant = TOP_CONSTRAINT_WITH_IMAGE
        } else {
            lblTitle.text = dataSource.title
        }
    }
    
    private func setComponents() {
        contentView.layer.cornerRadius = dataSource.alertViewRadius
        contentView.clipsToBounds = true
        contentView.backgroundColor = dataSource.alertViewBackgroundColor
        
        if let titleFont = dataSource.titleFont {
            lblTitle.font = titleFont
        }
        
        if let messageFont = dataSource.messageFont {
            lblMessage.font = messageFont
        }
        
        if let titleTextColor = dataSource.titleTextColor {
            lblTitle.textColor = titleTextColor
        }
        
        if let messageTextColor = dataSource.messageTextColor {
            lblMessage.textColor = messageTextColor
        }
        
        if dataSource.closeButtonVisibe {
            btnClose.isHidden = false
            if let image = dataSource.closeImage {
                btnClose.setImage(image, for: .normal)
            }
        }
    }
    
    private func addButtonsIfNeeded() {
        if dataSource.buttons.isEmpty {
            stackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            bottomConstraint.constant = 0
            return
        }
        
        stackView.axis = dataSource.axis
        for button in dataSource.buttons {
            stackView.addArrangedSubview(generateButton(source: button))
        }
    }
    
    private func generateButton(source: TemplateButtonDataSource) -> UIButton {
        let button = TemplateButton(source: source)
        button.onDidTap = { [weak self] in
            self?.onClose?()
        }

        return button
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        onClose?()
    }
}

extension DefaultAlertView {
    
    public enum AlertViewType: Int {
        case success
        case failure
        case warning
    }
    
    public enum OpeningAnimateType: Int {
        case fromTop
        case fromBottom
        case fromLeft
        case fromRight
        case fadeIn
    }
    
    public enum ClosingAnimateType: Int {
        case toTop
        case toBottom
        case toLeft
        case toRight
        case fadeOut
    }
    
    public class Builder {
                
        internal let alertDecorator = CustomAnimateDecorator(type: .center)
        private var alertView: DefaultAlertView?
        private var dataSource: DefaultAlertViewDataSource
        
        private var duration: Int = 0
        private var autoClose: Bool = false
        
        internal var openingAnimateType: OpeningAnimateType = .fromTop
        internal var closingAnimateType: ClosingAnimateType = .toBottom
        internal var fadeInEnabled: Bool = false
        
        public init(message: String, title: String? = nil) {
            self.dataSource = DefaultAlertViewDataSource(title: title, message: message)
            self.alertDecorator.blockUserInteractions = true
            
            setDecoratorAnimation()
        }
        
        private func setDecoratorAnimation() {
            alertDecorator.shadowViewAlphaValue = 0.6
            alertDecorator.openingAnimation = {
                self.openingAnimation()
            }
            
            alertDecorator.closingAnimation = {
                self.closingAnimation()
            }
        }
        
        @discardableResult
        public func setTitle(title: String) -> Builder {
            self.dataSource.title = title
            return self
        }
        
        @discardableResult
        public func setTitleTextColor(color: UIColor) -> Builder {
            self.dataSource.titleTextColor = color
            return self
        }
        
        @discardableResult
        public func setMessageTextColor(color: UIColor) -> Builder {
            self.dataSource.messageTextColor = color
            return self
        }
        
        @discardableResult
        public func setDirection(axis: NSLayoutConstraint.Axis) -> Builder {
            self.dataSource.axis = axis
            return self
        }
        
        @discardableResult
        public func setImage(imageName: String) -> Builder {
            self.dataSource.image = UIImage(named: imageName)
            return self
        }
        
        @discardableResult
        public func addButton(dataSource: TemplateButtonDataSource) -> Builder {
            self.dataSource.buttons.append(dataSource)
            return self
        }
        
        @discardableResult
        public func setAutoClose(enabled: Bool) -> Builder {
            self.autoClose = enabled
            return self
        }
        
        @discardableResult
        public func setDuration(duration: Int) -> Builder {
            setAutoClose(enabled: true)
            self.duration = duration
            return self
        }
        
        @discardableResult
        public func setCloseTappedAround(isEnabled: Bool) -> Builder {
            self.alertDecorator.closeTappedAround = isEnabled
            return self
        }
        
        @discardableResult
        public func setShadowViewAlphaValue(value: CGFloat) -> Builder {
            self.alertDecorator.shadowViewAlphaValue = value
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
        public func setOpeningAnimateType(type: OpeningAnimateType) -> Builder {
            self.openingAnimateType = type
            return self
        }
        
        @discardableResult
        public func setClosingAnimateType(type: ClosingAnimateType) -> Builder {
            self.closingAnimateType = type
            return self
        }
        
        @discardableResult
        public func setFadeInEnabled(enabled: Bool) -> Builder {
            self.fadeInEnabled = enabled
            return self
        }
        
        @discardableResult
        public func setAnimationOptions(options: UIView.AnimationOptions) -> Builder {
            self.alertDecorator.animationModel?.options = options
            return self
        }
        
        @discardableResult
        public func setCloseButtonVisibility(visible: Bool) -> Builder {
            self.dataSource.closeButtonVisibe = visible
            return self
        }
        
        @discardableResult
        public func setCloseButtonImage(image: UIImage) -> Builder {
            self.dataSource.closeImage = image
            return self
        }
        
        @discardableResult
        public func setAlertViewRadius(radius: CGFloat) -> Builder {
            self.dataSource.alertViewRadius = radius
            return self
        }
        
        @discardableResult
        public func setAlertViewBackgroundColor(color: UIColor) -> Builder {
            self.dataSource.alertViewBackgroundColor = color
            return self
        }
        
        public func getAlertView() -> DefaultAlertView {
            alertView = DefaultAlertView(dataSource: dataSource)
            alertView?.onClose = { [weak self] in
                self?.alertDecorator.closingAnimate()
            }
            return alertView!
        }
    
        public func show(alertViewType: AlertViewType) {
            dataSource.setImage(alertViewType: alertViewType)
            
            show()
        }
        
        public func show() {
            alertDecorator.constraintModel = ConstraintModel.Builder().build(type: .center)
            
            DecoratableAlertViewDataSource.Builder(alertView: getAlertView(), alertDecorator: alertDecorator)
                .setAutoCloseEnabled(enabled: autoClose)
                .show()
        }
    }
}
