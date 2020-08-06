//
//  ErrorView.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan Sönmez on 5.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class ErrorView: UIView, AlertViewProtocol {
    
    public var size = CGSize(width: 0, height: 60)
    
    public var onClose: (() -> Void)?
    
    public var containerViewBackgroundColor: UIColor? = .red
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lbl: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
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
    
    public func setErrorMessage(text: String) {
        lbl.text = text
    }
}
