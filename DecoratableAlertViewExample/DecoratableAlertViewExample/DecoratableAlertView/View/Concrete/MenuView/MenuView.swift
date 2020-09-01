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
    
    public var containerViewBackgroundColor: UIColor? = UIColor(rgb: 0x2A2A2A)
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var menus: MenuModel?
    fileprivate var onMenuSelect: ((MenuModel) -> Void)?
    
    private var selectedMenus: [MenuModel]?
    private var parents = [[MenuModel]]()
    
    fileprivate init() {
        super.init(frame: .zero)
        setUp()
    }
    
    fileprivate override init(frame: CGRect) {
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
        contentView.backgroundColor = containerViewBackgroundColor
    }
    
    public func reloadData() {
        selectedMenus = menus?.childs
        setTableView()
        tableView.reloadData()
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentView.systemLayoutSizeFitting(self.bounds.size)
    }
    
    public override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMenus?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let menu = selectedMenus![indexPath.row]
        cell.bind(text: menu.title ?? "")
        if indexPath.row == 0 && parents.count >= 1 {
            cell.showBackButton()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.hideBackButton()
        
        if parents.isEmpty {
            showChilds(indexPath: indexPath)
            return
        }
        
        if indexPath.row == 0 {
            showParent(indexPath: indexPath)
            return
        }
        
        if let rows = selectedMenus, rows[indexPath.row].childs == nil {
            onClose?()
            onMenuSelect?(rows[indexPath.row])
            return
        }
        
        showChilds(indexPath: indexPath)
    }
    
    
    private func showParent(indexPath: IndexPath) {
        guard !parents.isEmpty else { return }
        
        var insertedPath = [IndexPath]()
        var deletedPath = [IndexPath]()
        
        let parent = parents[parents.count - 1]
        
        var templateMenus = [MenuModel]()
        if var rows = selectedMenus {
            for index in 1..<rows.count {
                templateMenus.append(rows[index])
                deletedPath.append(IndexPath(row: index, section: 0))
            }
            
            for menu in templateMenus {
                if let index = rows.firstIndex(of: menu) {
                    rows.remove(at: index)
                }
            }
            
            let parentId = rows[0].id
            var foundedParent: Bool = false
            var topInsertIndex = 0
            for menu in parent {
                if menu.id != parentId {
                    if foundedParent {
                        rows.append(menu)
                        insertedPath.append(IndexPath(row: rows.count - 1, section: 0))
                    } else {
                        rows.insert(menu, at: topInsertIndex)
                        insertedPath.append(IndexPath(row: topInsertIndex, section: 0))
                        topInsertIndex += 1
                    }
                } else {
                    foundedParent = true
                }
            }
            
            self.selectedMenus = rows
            self.parents.removeLast()
            tableView.beginUpdates()
            tableView.deleteRows(at: deletedPath, with: .right)
            tableView.insertRows(at: insertedPath, with: .left)
            tableView.endUpdates()
        }
    }
    
    private func showChilds(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.showBackButton()
        
        var path = [IndexPath]()
        
        var templateMenus = [MenuModel]()
        var selectedMenuChilds: [MenuModel]?
        if var rows = selectedMenus {
            parents.append(rows)
            selectedMenuChilds = rows[indexPath.row].childs
            for index in 0..<rows.count {
                if index != indexPath.row {
                    path.append(IndexPath(row: index, section: 0))
                    templateMenus.append(rows[index])
                }
            }
            
            for menu in templateMenus {
                if let index = rows.firstIndex(of: menu) {
                    rows.remove(at: index)
                }
            }
            
            var insertPath = [IndexPath]()
            if let childs = selectedMenuChilds {
                for index in 0..<childs.count {
                    insertPath.append(IndexPath(row: index + 1, section: 0))
                    rows.append(childs[index])
                }
            }
            
            self.selectedMenus = rows
            tableView.beginUpdates()
            tableView.deleteRows(at: path, with: .left)
            tableView.insertRows(at: insertPath, with: .right)
            tableView.endUpdates()
        }
    }
}

extension MenuView {
    
    public class Builder {
        
        private var menus: MenuModel
        private var onMenuSelect: ((MenuModel) -> Void)?
        private var backgroundColor: UIColor = UIColor(rgb: 0x2A2A2A)
        
        public init(menus: MenuModel) {
            self.menus = menus
        }
        
        @discardableResult
        public func setOnMenuSelect(onMenuSelect: ((MenuModel) -> Void)?) -> Builder {
            self.onMenuSelect = onMenuSelect
            return self
        }
        
        @discardableResult
        public func setBackgroundColor(color: UIColor) -> Builder {
            self.backgroundColor = color
            return self
        }
        
        @discardableResult
        public func setCellBackgroundColor(color: UIColor) -> Builder {
            MenuCell.shared.colorOfBackground = color
            return self
        }
        
        @discardableResult
        public func setCellSelectedViewColor(color: UIColor) -> Builder {
            MenuCell.shared.colorOfSelectedView = color
            return self
        }
        
        @discardableResult
        public func setBackImage(image: UIImage) -> Builder {
            MenuCell.shared.backImg = image
            return self
        }
        
        @discardableResult
        public func setRightImage(image: UIImage) -> Builder {
            MenuCell.shared.rightImg = image
            return self
        }
        
        public func build() -> MenuView {
            let menuView = MenuView()
            menuView.menus = menus
            menuView.containerViewBackgroundColor = backgroundColor
            menuView.contentView.backgroundColor = backgroundColor
            menuView.onMenuSelect = onMenuSelect
            menuView.reloadData()
            return menuView
        }
    }
}
