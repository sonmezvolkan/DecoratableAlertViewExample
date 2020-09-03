//
//  NotificationViewDataSource.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 1.09.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

internal class NotificationViewDataSource {
    
    public var image: UIImage?
    public var title: String?
    public var description: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var descriptionFont: UIFont?
    public var descriptionColor: UIColor?
    public var backgroundColor: UIColor? = .black
    public var containerViewBackgroundColor: UIColor? = .clear
    
    internal init() {
        
    }
}
