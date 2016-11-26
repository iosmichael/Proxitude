//
//  ChooseTagsTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ChooseTagsTableViewController: UITableViewController , SelectTagCellProtocol{
    
    var selectedTagList = [String]()
    var tagList = [String]()
    let selectTagCellIdentifier = "SelectTagCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tagList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectTagTableViewCell = tableView.dequeueReusableCell(withIdentifier: selectTagCellIdentifier, for: indexPath) as! SelectTagTableViewCell
        cell.setText(text: tagList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func setup(){
        tableView.register(SelectTagTableViewCell.self, forCellReuseIdentifier: selectTagCellIdentifier)
        tableView.separatorStyle = .none
        let titleL: UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        titleL.textAlignment = .center
        titleL.font = UIFont.systemFont(ofSize: 18)
        titleL.text = "Choose Tags"
        tableView.tableHeaderView = titleL
        fillTags()
    }

    func fillTags(){
        tagList.insert("Sport Gears", at: 0)
        tagList.insert("Clothing", at: 0)
        tagList.insert("Jobs / Occupations", at: 0)
        tagList.insert("Furniture", at: 0)
        tagList.insert("Electronics", at: 0)
        tagList.insert("Entertainment", at: 0)
        tagList.insert("Textbook", at: 0)
    }
    
    func select(tag: String, isActive: Bool) {
        if isActive {
            selectedTagList.insert(tag, at: 0)
        }else{
            removeTag(tag: tag)
        }
    }
    
    func removeTag(tag:String){
        for i in 1...selectedTagList.count{
            if selectedTagList[i] == tag {
                selectedTagList.remove(at: i)
                return
            }
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
