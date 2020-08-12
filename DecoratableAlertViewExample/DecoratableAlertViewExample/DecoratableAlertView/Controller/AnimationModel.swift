//
//  AnimationModel.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 12.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class AnimationModel {
    
    public var animationTime: TimeInterval = 0.4
    public var delay: TimeInterval = 0
    public var usingSpringWithDamping: CGFloat = 1
    public var initialSpringVelocity: CGFloat = 1
    public var options: UIView.AnimationOptions = []
    
    public init() {
        
    }
    
}
