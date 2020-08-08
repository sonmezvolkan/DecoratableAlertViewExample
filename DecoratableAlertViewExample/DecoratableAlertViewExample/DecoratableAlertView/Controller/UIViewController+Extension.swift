//
//  UIViewController+Extension.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 7.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    public func showDecoratableAlertView(dataSource: DecoratableAlertViewDataSource) {
        DecoratableContext.main.start(controller: self, dataSource: dataSource)
    }
}
