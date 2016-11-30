//
//  HomeTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController?
    let itemCellIdentifier = "itemCell"
    let tagCellIdentifier = "tagCell"
    let itemCellHeight: CGFloat = 55
    let tagCellHeight: CGFloat = 40
    let bannerHeight:CGFloat = 120
    let whatsNewNum = 20
    let tagList = [("bith","BITH"),("humanities","HUMANITIES"),
                   ("science","SCIENCES"),("languages","LANGUAGES"),
                   ("other","OTHER")]
    var list = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fillData()
        navigationController?.masterNav()
        navigationController?.extendedLayoutIncludesOpaqueBars = false
        setupSearchBar()
        addPostBtn()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchStr = searchController.searchBar.text
        if (searchStr?.isEmpty)!{
            let resultController:SearchResultTableViewController = self.searchController?.searchResultsController as! SearchResultTableViewController
            resultController.items.removeAll()
            resultController.tableView.reloadData()
        }else{
            let resultController:SearchResultTableViewController = self.searchController?.searchResultsController as! SearchResultTableViewController
            resultController.items.removeAll()
            queryGetItems(searchStr: searchStr!)
        }
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //update tables correspondingly
        //and update scope
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? tagList.count : list.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? tagCellHeight : itemCellHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "What's New"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:TagTableViewCell = tableView.dequeueReusableCell(withIdentifier: tagCellIdentifier, for: indexPath) as! TagTableViewCell
            let (tagImage, tagName) = tagList[indexPath.row]
            cell.setIconTag(icon: UIImage.init(named: tagImage)!, tag: tagName)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath) as! ItemTableViewCell
            let item = list[indexPath.row]
            cell.setItem(item: item)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let categoryController = CategoryTableViewController()
            categoryController.queryType = .category
            categoryController.category = tagList[indexPath.row].1
            navigationController?.pushViewController(categoryController, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let itemDetailController:ItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "itemDetail") as! ItemDetailViewController
            itemDetailController.item = list[indexPath.row]
            navigationController?.pushViewController(itemDetailController, animated: true)
        }
    }
    
    func setup(){
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellIdentifier)
        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagCellIdentifier)
    }

    func fillData(){
        let query = Query()
        query.queryNew(limit: 200,sell:true).observe(.value, with: { snapshot in
            self.list = query.getItems(snapshot: snapshot,sell:true)
            self.tableView.reloadData()
        })
    }

    func addPostBtn(){
        let navRightBtn = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(presentPost))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func presentPost(){
        let logged = FIRAuth.auth()?.currentUser
        if logged == nil {
            let loginViewController = LogInViewController.init(nibName: "LogInViewController", bundle: nil)
            present(loginViewController, animated: true, completion: nil)
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let postViewController:PostItemViewController = storyboard.instantiateViewController(withIdentifier: "post") as! PostItemViewController
        postViewController.request = true
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func setupSearchBar(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let searchResultViewController:SearchResultTableViewController = storyboard.instantiateViewController(withIdentifier: "search") as! SearchResultTableViewController
        searchResultViewController.parentC = self
        searchController = UISearchController.init(searchResultsController: searchResultViewController)
        searchController?.extendedLayoutIncludesOpaqueBars = true
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        customizeSearchBar()
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    func customizeSearchBar(){
        let searchBar = searchController?.searchBar
        searchBar?.searchBarStyle = .prominent
        searchBar?.tintColor = UIColor.white
        searchBar?.barTintColor = UIColor.init(hex: "464646")
        searchBar?.placeholder = "Search here..."
        searchBar?.isTranslucent = false
        searchBar?.setTextColor(color: UIColor.white)
        searchBar?.setTextFieldBackgroundColor(color: UIColor.init(hex: "464646"))
        definesPresentationContext = true
    }
    
    func queryGetItems(searchStr:String){
        let query = Query()
        let resultController:SearchResultTableViewController = self.searchController?.searchResultsController as! SearchResultTableViewController
        query.queryBySearchStr(limit: 25, query: searchStr).observeSingleEvent(of:.value, with: { snapshot in
            resultController.items = query.getSimpleItems(snapshot: snapshot)
            print("Result: \(snapshot)")
            print(resultController.items)
            resultController.tableView.reloadData()
        })
    }

    
}
