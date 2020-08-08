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
        errorView.size = CGSize(width: 200, height: 80)
        errorView.setErrorMessage(text: "Volkan")
        let dataSource = DecoratableAlertViewDataSource.Builder(alertView: errorView, alertDecorator: TopSlideDecorator())
            .setAutoCloseTimeLimit(limit: 3)
            .setCanMove(canMove: true)
            .setAnimationTime(animationTime: 0.4)
            .build()
        
        showDecoratableAlertView(dataSource: dataSource)
        
    }
    @IBAction func btnCounter(_ sender: Any) {
        countIndex += 1
        lblCount.text = String(countIndex)
    }
}

