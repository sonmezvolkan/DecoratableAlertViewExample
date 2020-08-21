//
//  TemplateButton.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 21.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

internal class TemplateButton: UIButton {
    
    private let source: TemplateButtonDataSource
    public var onDidTap: (() -> Void)?
    
    internal init(source: TemplateButtonDataSource) {
        self.source = source
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setContents()
    }
    
    private func setContents() {
        setTitle(source.title, for: .normal)
        backgroundColor = source.buttonBackgroundColor
        layer.cornerRadius = source.buttonRadius
        clipsToBounds = true
        addTarget(self, action: #selector(self.onButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func onButtonDidTap() {
        self.source.onDidTap()
        onDidTap?()
    }
}
