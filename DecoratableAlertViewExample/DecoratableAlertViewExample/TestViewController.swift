//
//  TestViewController.swift
//  DecoratableAlertViewExample
//
//  Created by Volkan SÖNMEZ on 21.08.2020.
//  Copyright © 2020 Volkan Sönmez. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    private var menus: MenuModel?
    private var selectedMenus: [MenuModel]?
    private var parents = [[MenuModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        createMenu()
        tableView.reloadData()
    }
    
    private func createMenu() {
        self.menus = MockDataProvider.provideMenu()
        selectedMenus = menus?.childs
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMenus?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let menu = selectedMenus![indexPath.row]
        cell.bind(text: menu.title ?? "")
        print("\(parents.count)")
        if indexPath.row == 0 && parents.count >= 1 {
            cell.showBackButton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            print("menu aç")
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
