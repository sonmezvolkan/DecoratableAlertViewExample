//
//  AttachmentViewState.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 7.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

internal class DecoratableContext {

    internal static let main = DecoratableContext()
    
    private var dataSource: DecoratableAlertViewDataSource?
    private var controller: UIViewController?
    
    private var timer: Timer?
    private var timerIndex = 0
    
    private var mainView: UIView {
        if let tabbar = controller?.tabBarController {
            return tabbar.view
        }
        
        if let navController = controller?.navigationController {
            return navController.view
        }
        
        return controller!.view
    }
    
    private init() {
        
    }
    
    public func reset() {
        timerIndex = 0
        timer?.invalidate()
    }
    
    public func start(controller: UIViewController, dataSource: DecoratableAlertViewDataSource) {
        reset()
        self.dataSource = dataSource
        self.controller = controller

        setDecorator(dataSource: dataSource)
        setAutoCloseIfNeeded()
    }
    
    private func setAutoCloseIfNeeded() {
        if let dataSource = self.dataSource, dataSource.autoClose {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerClick),
                                              userInfo: nil, repeats: true)
        }
    }
    
    private func setDecorator(dataSource: DecoratableAlertViewDataSource) {
        dataSource.decorator.mainView = mainView
        dataSource.decorator.setConstraints()
        dataSource.decorator.openingAnimate()
    }
    
    @objc private func timerClick() {
        if dataSource?.timerLimit == timerIndex {
            reset()
            dataSource?.decorator.closingAnimate()
        }
        timerIndex += 1
    }
}
