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
    
    internal init() {
        
    }
    
    public init(leadingConstraint: CGFloat?, trailingCosntraint: CGFloat?, topConstraint: CGFloat?, bottomConstraint: CGFloat?) {
        self.leadingConstraint = leadingConstraint
        self.trailingCosntraint = trailingCosntraint
        self.topConstraint = topConstraint
        self.bottomConstraint = bottomConstraint
    }
}
