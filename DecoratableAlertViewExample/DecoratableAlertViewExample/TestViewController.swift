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
        self.menus = MenuModel(id: 0)
        
        var menu1 = MenuModel(id: 1)
        menu1.title = "Menu 1"
        
        var menu2 = MenuModel(id: 2)
        menu2.title = "Menu 2"
        
        var menu3 = MenuModel(id: 3)
        menu3.title = "Menu 3"
        
        var menu11 = MenuModel(id: 11)
        menu11.title = "Menu 1 - 1"
        
        var menu12 = MenuModel(id: 12)
        menu12.title = "Menu 1 - 2"
        
        var menu13 = MenuModel(id: 13)
        menu13.title = "Menu 1 - 3"
        
        var menu14 = MenuModel(id: 14)
        menu14.title = "Menu 1 - 4"
        
        var menu21 = MenuModel(id: 21)
        menu21.title = "Menu 2 - 1"
        
        var menu211 = MenuModel(id: 211)
        menu211.title = "Menu 2 - 1 - 1"
        
        var menu212 = MenuModel(id: 212)
        menu212.title = "Menu 2 - 1 - 2"
        
        var menu213 = MenuModel(id: 213)
        menu213.title = "Menu 2 - 1 - 3"
        
        menu21.childs = [ menu211, menu212, menu213]
        
        
        var menu22 = MenuModel(id: 22)
        menu22.title = "Menu 2 - 2"
        
        var menu221 = MenuModel(id: 221)
        menu221.title = "Menu 2 - 2 - 1"
        
        var menu222 = MenuModel(id: 222)
        menu222.title = "Menu 2 - 2 - 2"
        
        menu22.childs = [menu221, menu222 ]
        
        var menu23 = MenuModel(id: 23)
        menu23.title = "Menu 2 - 3"
        
        var menu24 = MenuModel(id: 24)
        menu24.title = "Menu 2 - 4"
        
        var menu25 = MenuModel(id: 25)
        menu25.title = "Menu 2 - 5"
        
        var menu26 = MenuModel(id: 26)
        menu26.title = "Menu 2 - 6"
        
        var menu31 = MenuModel(id: 31)
        menu31.title = "Menu 3 - 1"
        
        var menu32 = MenuModel(id: 32)
        menu32.title = "Menu 3 - 2"
        
        menu1.childs = [ menu11, menu12, menu13, menu14]
        
        menu2.childs = [menu21, menu22, menu23, menu24, menu25, menu26]
        
        menu3.childs = [menu31, menu32]
        
        menus?.childs = [ menu1, menu2, menu3 ]
        
        selectedMenus = menus?.childs
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMenus?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let menu = selectedMenus![indexPath.row]
        cell.bind(text: menu.title ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if parents.isEmpty {
            showChilds(indexPath: indexPath)
            return
        }
        
        indexPath.row == 0 ? showParent(indexPath: indexPath) : showChilds(indexPath: indexPath)
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
                if let index = rows.index(of: menu) {
                    rows.remove(at: index)
                }
            }
            
            var parentId = rows[0].id
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
            tableView.deleteRows(at: deletedPath, with: .none)
            tableView.insertRows(at: insertedPath, with: .left)
            tableView.endUpdates()
        }
        
    }
    
    private func showChilds(indexPath: IndexPath) {
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
                if let index = rows.index(of: menu) {
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
            tableView.deleteRows(at: path, with: .none)
            tableView.insertRows(at: insertPath, with: .right)
            tableView.endUpdates()
        }
    }
}
