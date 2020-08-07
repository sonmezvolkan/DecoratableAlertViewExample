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
    
    var alertView: AlertViewProtocol? { get set }
    
    var constraintModel: ConstraintModel? { get set }
    
    var onClose: (() -> Void)? { get set }
    
    var canMove: Bool { get set }
    
    var blockUserInteractions: Bool { get set }
    
    var closeTappedAround: Bool { get set }
    
    var animationTime: TimeInterval { get set }
    
    var closeableZoneRatio: CGFloat { get set }
    
    func setConstraints()
    
    func openingAnimate()
    
    func closingAnimate()
    
}
