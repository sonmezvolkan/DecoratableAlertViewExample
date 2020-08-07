//
//  DecoratableAlertViewProtocol.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public protocol AlertViewProtocol where Self: UIView {
    
    var size: CGSize { get set }
    
    var onClose: (() -> Void)? { get set }
    
    var containerViewBackgroundColor: UIColor? { get set }
    
    func resizeView()
}

