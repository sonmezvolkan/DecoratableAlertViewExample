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
    public var radius: CGFloat?
    
    internal init() {
        
    }
    
    internal init(image: UIImage?, title: String?, description: String?,
                  titleFont: UIFont?, titleColor: UIColor?,
                  descriptionFont: UIFont?, descriptionColor: UIColor?, radius: CGFloat?) {
        self.image = image
        self.title = title
        self.description = description
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.descriptionFont = descriptionFont
        self.descriptionColor = descriptionColor
        self.radius = radius
    }
}
