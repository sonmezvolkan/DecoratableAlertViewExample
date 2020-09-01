//
//  NotificationView.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 1.09.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

public class NotificationView: UIView, AlertViewProtocol {
    
    public var onClose: (() -> Void)?
    
    public var containerViewBackgroundColor: UIColor? = .clear
    
    public var containerViewAlphaValue: CGFloat? = 0.6
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    private let dataSource: NotificationViewDataSource
    
    fileprivate init(dataSource: NotificationViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("NotificationView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .black
        addSubview(contentView)
        
        setControls()
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentView.systemLayoutSizeFitting(self.bounds.size)
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setControls() {
        setContentView()
        setImageView()
        setTitle()
        setDescription()
    }
    
    private func setContentView() {
        if let radius = dataSource.radius {
            contentView.layer.cornerRadius = radius
            contentView.clipsToBounds = true
        }
    }
    
    private func setImageView() {
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.clipsToBounds = true
        
        if let image = dataSource.image {
            imgView.image = image
        } else {
            imgView.image = UIImage(named: "bell")
            imgView.tintColor = .white
        }
    }
    
    private func setTitle() {
        lblTitle.text = dataSource.title
        
        if let font = dataSource.titleFont {
            lblTitle.font = font
        }
        
        if let color = dataSource.titleColor {
            lblTitle.textColor = color
        }
    }
    
    private func setDescription() {
        lblDescription.text = dataSource.description
        
        if let font = dataSource.descriptionFont {
            lblDescription.font = font
        }
        
        if let color = dataSource.descriptionColor {
            lblDescription.textColor = color
        }
    }
}

extension NotificationView {
    
    public class Builder {
        
        private var dataSource: NotificationViewDataSource
        
        public init() {
            dataSource = NotificationViewDataSource()
        }
        
        @discardableResult
        public func setImage(image: UIImage) -> Builder {
            dataSource.image = image
            return self
        }
        
        @discardableResult
        public func setTitle(title: String) -> Builder {
            dataSource.title = title
            return self
        }
        
        @discardableResult
        public func setDescription(description: String) -> Builder {
            dataSource.description = description
            return self
        }
        
        @discardableResult
        public func setTitleFont(font: UIFont) -> Builder {
            dataSource.titleFont = font
            return self
        }
        
        @discardableResult
        public func setTitleColor(color: UIColor) -> Builder {
            dataSource.titleColor = color
            return self
        }
        
        @discardableResult
        public func setDescriptionFont(font: UIFont) -> Builder {
            dataSource.descriptionFont = font
            return self
        }
        
        @discardableResult
        public func setDescriptionColor(color: UIColor) -> Builder {
            dataSource.descriptionColor = color
            return self
        }
        
        @discardableResult
        public func setRadius(radius: CGFloat) -> Builder {
            dataSource.radius = radius
            return self
        }
        
        public func build() -> NotificationView {
            let notificationView = NotificationView(dataSource: dataSource)
            return notificationView
        }
    }
}
