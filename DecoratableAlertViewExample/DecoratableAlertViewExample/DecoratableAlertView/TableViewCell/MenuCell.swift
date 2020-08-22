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
    
    public func bind(text: String) {
        self.lblMenu.text = text
    }
    
}
