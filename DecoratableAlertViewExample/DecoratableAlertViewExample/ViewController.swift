//
//  ViewController.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        <#code#>
    }
    
    @IBAction func btnShow(_ sender: Any) {
        let errorView = ErrorView()
        errorView.setErrorMessage(text: "Volkan\nVolkan\nVolkan")
        let builder = DecoratableAlertViewController.Builder(alertView: errorView,
                                             alertDecorator: BottomSlideDecorator())
        
        builder.setCanMove(canMove: true)
        builder.setAutoCloseTimeLimit(limit: 5)
        builder.show()
    }
}

