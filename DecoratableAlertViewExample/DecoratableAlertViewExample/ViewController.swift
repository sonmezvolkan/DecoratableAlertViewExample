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
        errorView.setErrorMessage(text: "Volkan Volkan Deneme\nDeneme 2\nVa\na\nafa\nasda\nfsdf\n")
        
        let menuView = MenuView()
        
        let constraints = ConstraintModel.Builder()
            .build(type: .top)
    
        
        DefaultAlertView.Builder(message: "Volkan mesaj denemesi bakalım ne olacak deneme metni ne olacak hayırdır inşallah ")
            .setTitle(title: "Volkan Sümerya")
            .setDirection(axis: .horizontal)
            //.setImage(imageName: "success")
            .addButton(dataSource: generateButton())
            .addButton(dataSource: generateButton2())
            .addButton(dataSource: generateButton3())
            .setCloseButtonVisibility(visible: true)
            .setCloseTappedAround(isEnabled: false)
            .setUsingSpringWithDamping(ratio: 0.8)
            .setInitialSpringVelocity(value: 0.5)
            .setAnimationOptions(options: .curveEaseInOut)
            .show()
        

       

//        let decorator = TopSlideDecorator()
//
//        DecoratableAlertViewDataSource.Builder(alertView: errorView, alertDecorator: decorator)
//            .setDuration(duration: 30)
//            .setCanMove(canMove: true)
//            .setAnimationTime(animationTime: 0.4)
//            .setBlockUserInteractions(isEnabled: true)
//            .setCloseTappedAround(isEnabled: true)
//            .setShadowViewAlphaValue(value: 0)
//            .setClosableZoneRatio(ratio: 0.7)
//            .show()
        
    }
    
    @IBAction func btnCounter(_ sender: Any) {
        countIndex += 1
        lblCount.text = String(countIndex)
    }
    
    private func generateButton() -> TemplateButtonDataSource {
        let source = TemplateButtonDataSource.Builder(title: "Volkan", onDidTap: { [weak self] in
            print("tıklandı")
        })
    
        return source.build()
    }
    
    private func generateButton2() -> TemplateButtonDataSource {
        let source = TemplateButtonDataSource.Builder(title: "Volkan", onDidTap: { [weak self] in
            print("tıklandı 2")
        })
    
        return source.build()
    }
    
    private func generateButton3() -> TemplateButtonDataSource {
        let source = TemplateButtonDataSource.Builder(title: "Volkan", onDidTap: { [weak self] in
            print("tıklandı 3")
        })
    
        return source.build()
    }
}

