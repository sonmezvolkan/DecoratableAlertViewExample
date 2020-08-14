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
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblMessageTopConstraint: NSLayoutConstraint!
    
    private var title: String?
    private var message: String?
    private var buttons: [UIButton]?
    private var axis: NSLayoutConstraint.Axis = .horizontal
    private var image: UIImage?
    private var width: CGFloat = 0
    
    private var TOP_CONSTRAINT_WITH_IMAGE: CGFloat = 112
    
    fileprivate init(title: String?, message: String,
                     buttons: [UIButton], axis: NSLayoutConstraint.Axis,
                     image: UIImage?, width: CGFloat) {
        super.init(frame: .zero)
        self.title = title
        self.message = message
        self.buttons = buttons
        self.axis = axis
        self.image = image
        self.width = width
        
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
        setViewWidth()
        setTopOfAlertView()
        lblMessage.text = message
        addButtonsIfNeeded()
    }
    
    private func setViewWidth() {
        contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    private func setTopOfAlertView() {
        let isImageExist = self.image != nil
        
        lblTitle.isHidden = isImageExist
        imageView.isHidden = !isImageExist
        
        if isImageExist {
            imageView.image = self.image
            lblMessageTopConstraint.constant = TOP_CONSTRAINT_WITH_IMAGE
        } else {
            lblTitle.text = title
        }
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
    
    public enum AlertViewType: Int {
        case success
        case failure
        case warning
    }
    
    public class Builder {
        
        private let bundle = Bundle.main
        private let alertDecorator = FadeInDecorator()
        
        private var title: String?
        private var titleFont: UIFont?
        private var message: String
        private var messageFont: UIFont?
        private var buttons: [UIButton] = []
        private var axis: NSLayoutConstraint.Axis = .horizontal
        private var image: UIImage?
        private var width = UIScreen.main.bounds.width - 72
        
        private var duration: Int = 0
        private var autoClose: Bool = false
        
        public init(message: String) {
            self.message = message
            self.alertDecorator.blockUserInteractions = true
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
        public func setImage(imageName: String) -> Builder {
            self.image = UIImage(named: imageName)
            return self
        }
        
        @discardableResult
        public func addButton(button: UIButton) -> Builder {
            self.buttons.append(button)
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
        public func setAnimationOptions(options: UIView.AnimationOptions) -> Builder {
            self.alertDecorator.animationModel?.options = options
            return self
        }
        
        public func getAlertView() -> DefaultAlertView {
            return DefaultAlertView(title: title,
                                    message: message,
                                    buttons: buttons,
                                    axis: axis,
                                    image: image,
                                    width: width)
        }
    
        
        public func show(alertViewType: AlertViewType) {
            setImage(alertViewType: alertViewType)
            
            show()
        }
        
        private func setImage(alertViewType: AlertViewType) {
            switch alertViewType {
            case .success:
                image = UIImage(named: "success", in: bundle, compatibleWith: nil)
            case .failure:
                image = UIImage(named: "failure", in: bundle, compatibleWith: nil)
            case .warning:
                image = UIImage(named: "warning", in: bundle, compatibleWith: nil)
            }
        }
        
        public func show() {
            guard let controller = UIApplication.getTopMostViewController() else { return }
         
            alertDecorator.constraintModel = ConstraintModel.Builder().build(type: .center)
            
            let dataSource = DecoratableAlertViewDataSource.Builder(alertView: getAlertView(), alertDecorator: alertDecorator)
                .setAutoCloseEnabled(enabled: autoClose)
                .build()
            
            controller.showDecoratableAlertView(dataSource: dataSource)
            
        }
     
    }
}
