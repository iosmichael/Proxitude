//
//  SearchResultTableViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/24/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {

    var tags = [String]()
    var items = [String]()
    let tagIdentifier = "tagCell"
    let itemIdentifier = "itemCell"
    let tagHeight = 44
    let itemHeight = 55
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        test()
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? tags.count : items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(indexPath.section == 0 ? tagHeight : itemHeight)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "By Tags" : "By Title"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tagIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func setup(){
        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagIdentifier)
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemIdentifier)
        
    }
    
    func test(){
        tags.append("Mac")
        tags.append("Mac")
        tags.append("Mac")
        items.append("Burrito")
        items.append("Burrito")
        items.append("Burrito")
        items.append("Burrito")
        items.append("Burrito")
        items.append("Burrito")
        items.append("Burrito")
    }
    

}
