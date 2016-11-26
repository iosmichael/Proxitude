//
//  ProfileTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    let tagCellIdentifier = "tagCell"
    let contactCellIdentifier = "contactCell"
    let tagCellHeight: CGFloat = 44
    let contactCellHeight: CGFloat = 70
    var list = [(UIImage,String)]()
    
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : list.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? contactCellHeight : tagCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath)
            return cell
        }else{
            let cell:TagTableViewCell = tableView.dequeueReusableCell(withIdentifier: tagCellIdentifier, for: indexPath) as! TagTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.setIconTag(icon: list[indexPath.row].0, tag: list[indexPath.row].1)
            return cell
        }
    }

    func setup(){
        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagCellIdentifier)
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellIdentifier)
    }
    
    func fillData(){
        list.insert((UIImage.init(named: "tagIcon")!,"Test-Login-Page"), at: 0)
        list.insert((UIImage.init(named: "tagIcon")!,"Report a Problem"), at: 0)
        list.insert((UIImage.init(named: "tagIcon")!,"About"), at: 0)
        list.insert((UIImage.init(named: "tagIcon")!,"Messages"), at: 0)
        list.insert((UIImage.init(named: "tagIcon")!,"QR Scanner"), at: 0)
        list.insert((UIImage.init(named: "tagIcon")!,"My Items"), at: 0)
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

   
}
