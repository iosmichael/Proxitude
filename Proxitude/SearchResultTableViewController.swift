//
//  SearchResultTableViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/24/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {

    var items = [Item]()
    let itemIdentifier = "itemCell"
    let itemHeight = 55
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationController?.masterNav()
        navigationController?.extendedLayoutIncludesOpaqueBars = true;

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(itemHeight)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier, for: indexPath) as! ItemTableViewCell
            let item = items[indexPath.row]
            cell.setItem(item: item)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
    }
    
    
    func setup(){
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemIdentifier)
    }

}
