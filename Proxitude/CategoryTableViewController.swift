//
//  CategoryTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/28/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase
enum QueryType{
    case category
    case myItem
}

class CategoryTableViewController: UITableViewController {
    
    var items = [Item]()
    var queryType: QueryType?
    var category:String?
    let itemCellIdentifier = "itemCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        query()
        navigationController?.masterNav()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath) as! ItemTableViewCell
        cell.setItem(item: items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func setup(){
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if queryType == .myItem{
            let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
                let item = self.items[indexPath.row]
                item.deleteItem(itemID: item.itemId)
            }
            deleteAction.backgroundColor = UIColor.red
            return [deleteAction]
        }
        return nil
    }
    
    func query(){
        if queryType! == .category {
            let query = Query()
            query.queryNew(limit: 20,sell:true).observe(.value, with: { snapshot in
                self.items = query.getItems(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }else{
            let query = Query()
            if let user = FIRAuth.auth()?.currentUser {
                for profile in user.providerData {
                    query.queryItemByUser(user: profile.email!).observe(.value, with: { snapshot in
                        self.items = query.getItems(snapshot: snapshot)
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
}
