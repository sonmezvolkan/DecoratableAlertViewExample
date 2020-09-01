//
//  MenuCell.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 21.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class MenuCell: UITableViewCell {
    
    public static let shared = MenuCell()
    
    public var colorOfBackground = UIColor(rgb: 0x2A2A2A)
    public var colorOfSelectedView = UIColor.black
    public var backImg = UIImage(named: "back")
    public var rightImg = UIImage(named: "right")
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = MenuCell.shared.colorOfBackground
        let selectedView = UIView()
        selectedView.backgroundColor = MenuCell.shared.colorOfSelectedView
        selectedBackgroundView = selectedView
        rightImage.image = MenuCell.shared.rightImg
        backImage.image = MenuCell.shared.backImg
    }
    
    public func bind(text: String) {
        self.lblMenu.text = text
        backImage.isHidden = true
        rightImage.isHidden = false
    }
    
    public func showBackButton() {
        backImage.isHidden = false
        rightImage.isHidden = true
    }
    
    public func hideBackButton() {
        backImage.isHidden = true
        rightImage.isHidden = false
    }
}
