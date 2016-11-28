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
    var tagList = ["Sport Gears","Clothing","Furniture","Electronics","Entertainment","Textbook"]
    weak var parentC: PostItemViewController?
    let selectTagCellIdentifier = "SelectTagCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNav()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
        cell.delegate = self
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
    }
    
    func select(tag: String, isActive: Bool) {
        if isActive {
            selectedTagList.insert(tag, at: 0)
        }else{
            removeTag(tag: tag)
        }
        print("selected Tags: \(selectedTagList)")
    }
    
    func removeTag(tag:String){
        for i in 0...selectedTagList.count-1{
            if selectedTagList[i] == tag {
                selectedTagList.remove(at: i)
                return
            }
        }
    }
    
    func setupNav(){
        let navLeftBtn = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(dismissCurrent))
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func dismissCurrent(){
        parentC?.fillTags(tags: selectedTagList)
        self.navigationController?.popViewController(animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
