//
//  DecoratableAlertViewController.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class DecoratableAlertViewController: UIViewController {

    private var alertView: AlertViewProtocol?
    private var customAlertView: UIView?
    private var mainView: UIView?
    private var alertDecorator: AlertViewDecoratorProtocol?
    
    private var timer: Timer?
    private lazy var timerClickIndex: Int = 0
    private lazy var timerLimit = 5
    private var autoClose: Bool = true
    
    public var onClose: (() -> Void)?
    
    private var currentSuperView: UIView {
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate init(alertView: AlertViewProtocol, alertDecorator: AlertViewDecoratorProtocol,
                     autoClose: Bool, timerLimit: Int, closeTappedAround: Bool, closableZoneRatio: CGFloat,
                     superViewBackgroundColor: UIColor, animationTime: TimeInterval, canMove: Bool, constraints: ConstraintModel?) {
        super.init(nibName: nil, bundle: nil)
        if customAlertView != nil { return }
        
        self.alertView = alertView
        self.timerLimit = timerLimit
        self.alertDecorator = alertDecorator
        self.autoClose = autoClose
        alertDecorator.closeTappedAround = closeTappedAround
        alertDecorator.animationTime = animationTime
        alertDecorator.closeableZoneRatio = closableZoneRatio
        alertDecorator.canMove = canMove
        alertDecorator.constraintModel = constraints
        self.initMainView()
        self.configureDecorator(alertView: alertView)
        self.setOnClose()
    
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertDecorator?.openingAnimate()
    
        if autoClose {
            initAutoClose()
        }
    }
    
    fileprivate func showCustomAlertView(alertView: AlertViewProtocol,
                                         alertDecorator: AlertViewDecoratorProtocol,
                                         autoClose: Bool, timerLimit: Int,
                                         closeTappedAround: Bool,
                                         closableZoneRatio: CGFloat,
                                         superViewBackgroundColor: UIColor,
                                         animationTime: TimeInterval,
                                         canMove: Bool) {
        if customAlertView != nil { return }

        self.timerLimit = timerLimit
        self.alertDecorator = alertDecorator
        alertDecorator.closeTappedAround = closeTappedAround
        alertDecorator.animationTime = animationTime
        alertDecorator.closeableZoneRatio = closableZoneRatio
        alertDecorator.canMove = canMove
        

        
        initMainView()
        configureDecorator(alertView: alertView)
        setOnClose()
    }
    
    private func initMainView() {
        mainView = UIView()
        guard let mainView = self.mainView else { return }
        mainView.backgroundColor = .clear
        mainView.frame = UIScreen.main.bounds
        currentSuperView.addSubview(mainView)
    }
    
    private func configureDecorator(alertView: AlertViewProtocol) {
        guard let alertDecorator = self.alertDecorator else { return }
        generateCustomAlertView(alertView: alertView)
        alertDecorator.mainView = mainView
        alertDecorator.containerView = customAlertView
        alertDecorator.alertView = alertView
        alertDecorator.setConstraints()
    }
    
    private func generateCustomAlertView(alertView: AlertViewProtocol) {
        guard let mainView = self.mainView else { return }
        customAlertView = UIView()
        guard let customAlertView = self.customAlertView else { return }
        
        mainView.addSubview(customAlertView)
        customAlertView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addContentView(customAlertView: UIView, alertView: AlertViewProtocol) {
        customAlertView.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: customAlertView.topAnchor).isActive = true
        alertView.bottomAnchor.constraint(equalTo: customAlertView.bottomAnchor).isActive = true
        
        customAlertView.layoutIfNeeded()
    }
    
    private func initAutoClose() {
        timerClickIndex = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerClick),
                                          userInfo: nil, repeats: true)
    }
    
    @objc private func timerClick() {
        if timerLimit == timerClickIndex {
            timer?.invalidate()
            timerClickIndex = 0
            alertDecorator?.closingAnimate()
        }
        timerClickIndex += 1
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertDecorator?.touchesBegan(touches: touches, event: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertDecorator?.touchesMoved(touches: touches, event: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertDecorator?.touchesEnd(touches: touches, event: event)
    }
    
    public class Builder {
        
        private var alertView: AlertViewProtocol
        private var alertDecorator: AlertViewDecoratorProtocol
        private var autoClose: Bool = false
        private var timerLimit: Int = 15
        private var closeTappedAround: Bool = true
        private var superViewBackgroundColor: UIColor = .clear
        private var animationTime: TimeInterval = 0.4
        private var canMove: Bool = true
        private var closableZoneRatio: CGFloat = 0.3
        private var constraints: ConstraintModel?
        
        public init(alertView: AlertViewProtocol,
                    alertDecorator: AlertViewDecoratorProtocol) {
            self.alertView = alertView
            self.alertDecorator = alertDecorator
        }
        
        private func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopMostViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return getTopMostViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return getTopMostViewController(base: presented)
            }
            return base
        }
        
        @discardableResult
        public func setAutoCloseDisabled() -> Builder {
            self.autoClose = false
            return self
        }
        
        @discardableResult
        public func setAutoCloseTimeLimit(limit: Int) -> Builder {
            self.timerLimit = limit
            return self
        }
        
        @discardableResult
        public func setCloseTappedAround(isEnabled: Bool) -> Builder {
            self.closeTappedAround = isEnabled
            return self
        }

        @discardableResult
        public func setClosableZoneRatio(ratio: CGFloat) -> Builder {
            if ratio <= 0 || ratio > 1 { fatalError("Ratio can not be 0 and higher than 1") }
            self.closableZoneRatio = ratio
            return self
        }
        
        @discardableResult
        public func setSuperViewBackgroundColor(color: UIColor) -> Builder {
            self.superViewBackgroundColor = color
            return self
        }
        
        @discardableResult
        public func setAnimationTime(animationTime: TimeInterval) -> Builder {
            self.animationTime = animationTime
            return self
        }
        
        @discardableResult
        public func setCanMove(canMove: Bool) -> Builder {
            self.canMove = canMove
            return self
        }
        
        @discardableResult
        public func setConstraints(constrains: ConstraintModel) -> Builder {
            self.constraints = constrains
            return self
        }
        
        @discardableResult
        public func setConstraints(constraints: ConstraintModel) -> Builder {
            self.constraints = constraints
            return self
        }
        
        @discardableResult
        public func setLeadingConstrint(constant: CGFloat) -> Builder {
            let constraints = getConstraints()
            constraints.leadingConstraint = constant
            return self
        }
        
        @discardableResult
        public func setTrailingConstraint(constant: CGFloat) -> Builder {
            let constraints = getConstraints()
            constraints.trailingCosntraint = constant
            return self
        }
        
        @discardableResult
        public func setTopConstraint(constant: CGFloat) -> Builder {
            let constraints = getConstraints()
            constraints.topConstraint = constant
            return self
        }
        
        @discardableResult
        public func setBottomConstraint(constant: CGFloat) -> Builder {
            let constraints = getConstraints()
            constraints.bottomConstraint = constant
            return self
        }
        
        private func getConstraints() -> ConstraintModel {
            if self.constraints == nil {
                self.constraints = ConstraintModel()
            }
            return self.constraints!
        }
        
        public func show() {
            guard let viewController = self.getTopMostViewController() else { return }
            let alertController = DecoratableAlertViewController(alertView: alertView,
                                                                 alertDecorator: alertDecorator,
                                                                 autoClose: autoClose,
                                                                 timerLimit: timerLimit,
                                                                 closeTappedAround: closeTappedAround,
                                                                 closableZoneRatio: closableZoneRatio,
                                                            superViewBackgroundColor: superViewBackgroundColor,
                                                            animationTime: animationTime, canMove: canMove, constraints: constraints)
            alertController.modalPresentationStyle = .overFullScreen
            viewController.present(alertController, animated: false, completion: nil)
        }
    }
}

// MARK: - Public Methods
extension DecoratableAlertViewController {
    
    public func setOnClose() {
        alertDecorator?.onClose = { [weak self] in
            self?.timer?.invalidate()
            self?.onClose?()
            self?.dismiss(animated: false, completion: nil)
        }
        
        alertView?.onClose = { [weak self] in
              self?.alertDecorator?.closingAnimate()
          }
    }
}
