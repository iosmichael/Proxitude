//
//  SaveTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class SaveTableViewController: UITableViewController {

    let itemCellIdentifier = "itemCell"
    let itemCellHeight: CGFloat = 55
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.masterNav()
        addPostBtn()
        setup()
        fillData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let itemDetailController = storyboard.instantiateViewController(withIdentifier: "itemDetail")
        navigationController?.pushViewController(itemDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemCellHeight
    }
    
    func setup(){
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellIdentifier)
    }
    
    func fillData(){
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
        list.insert("Mac", at: 0)
    }

    func addPostBtn(){
        let navRightBtn = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(presentPost))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func presentPost(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "post")
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
}
