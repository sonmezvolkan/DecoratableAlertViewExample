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
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 41, green: 80, blue: 251, alpha: 0)
        let selectedView = UIView()
        selectedView.backgroundColor = .red
        selectedBackgroundView = selectedView
    }
    
    public func bind(text: String) {
        self.lblMenu.text = text
        backImage.isHidden = true
    }
    
    public func showBackImage() {
        backImage.isHidden = false
    }
    
}
