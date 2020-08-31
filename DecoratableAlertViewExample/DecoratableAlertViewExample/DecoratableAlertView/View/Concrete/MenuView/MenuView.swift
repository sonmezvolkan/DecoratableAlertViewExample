//
//  MenuView.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 9.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class MenuView: UIView, AlertViewProtocol {
    
    public var onClose: (() -> Void)?
    
    public var containerViewBackgroundColor: UIColor?
    
    public var containerViewAlphaValue: CGFloat?
    
    @IBOutlet var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentView.systemLayoutSizeFitting(self.bounds.size)
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
