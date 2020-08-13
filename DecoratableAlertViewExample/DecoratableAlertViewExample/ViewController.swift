//
//  ViewController.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var countIndex: Int = 0
    @IBOutlet weak var lblCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnShow(_ sender: Any) {
        let errorView = ErrorView()
        errorView.setErrorMessage(text: "Volkan\nVolkan\nDeneme\nDeneme 2\nVa\na\nafa\nasda\nfsdf\n")
        
        let menuView = MenuView()
        
        let constraints = ConstraintModel.Builder()
            .setTopConstraint(constant: 86)
            .setCenterXConstraint(constant: 0)
            .build()
        
        let customDecorator = CustomAnimateDecorator(constraints: constraints)
        customDecorator.openingAnimation = {
            customDecorator.containerView.transform = CGAffineTransform(translationX: -300, y: 0)
            UIView.animate(withDuration: 0.5, animations: {
                customDecorator.containerView.transform = .identity
            })
        }
        
        customDecorator.closingAnimation = {
             UIView.animate(withDuration: 0.5, animations: {
                 customDecorator.containerView.transform = CGAffineTransform(translationX: 400, y: 0)
             }, completion: { isFinished in
                customDecorator.removeViews()
             })
        }
        
        let dataSource = DecoratableAlertViewDataSource.Builder(alertView: errorView, alertDecorator: customDecorator)
            .setAutoCloseTimeLimit(limit: 30)
            .setCanMove(canMove: true)
            .setAnimationTime(animationTime: 1.0)
            .setBlockUserInteractions(isEnabled: true)
            .setCloseTappedAround(isEnabled: true)
            .setShadowViewAlphaValue(value: 0)
            .setClosableZoneRatio(ratio: 0.7)
            .build()
        
        showDecoratableAlertView(dataSource: dataSource)
        
    }
    @IBAction func btnCounter(_ sender: Any) {
        countIndex += 1
        lblCount.text = String(countIndex)
    }
}

