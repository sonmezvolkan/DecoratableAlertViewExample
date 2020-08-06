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
    
    @IBAction func btnShow(_ sender: Any) {
        let errorView = ErrorView()
        errorView.size = CGSize(width: 200, height: 80)
        errorView.setErrorMessage(text: "Volkan")
        let builder = DecoratableAlertViewController.Builder(alertView: errorView,
                                             alertDecorator: RightSlideDecorator())
        
        builder.setCanMove(canMove: true)
        builder.setAutoCloseTimeLimit(limit: 5)
        builder.show()
    }
}

