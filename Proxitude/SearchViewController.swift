//
//  SearchViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController?
    var items = [Item]()
    let tagIdentifier = "tagCell"
    let itemIdentifier = "itemCell"
    let tagHeight = 40
    let itemHeight = 55
    
    let whatsNewNum = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationController?.masterNav()
        navigationController?.extendedLayoutIncludesOpaqueBars = true
        addPostBtn()
        fillData()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(itemHeight)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "New Request"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier, for: indexPath) as! ItemTableViewCell
            let item = items[indexPath.row]
            cell.setItem(item: item)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            let categoryController = CategoryTableViewController()
//            categoryController.queryType = .category
//            categoryController.category = tagList[indexPath.row].1
//            navigationController?.pushViewController(categoryController, animated: true)
//        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let itemDetailController:ItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "itemDetail") as! ItemDetailViewController
            itemDetailController.item = items[indexPath.row]
            itemDetailController.request = false
            navigationController?.pushViewController(itemDetailController, animated: true)
//        }
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        let searchStr = searchController.searchBar.text
        if (searchStr?.isEmpty)!{
            let resultController:SearchResultTableViewController = self.searchController?.searchResultsController as! SearchResultTableViewController
            resultController.items.removeAll()
            resultController.tableView.reloadData()
        }else{
            queryGetItems(searchStr: searchStr!)
        }
    }
    
    
    func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
//        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagIdentifier)
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemIdentifier)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let searchResultViewController:SearchResultTableViewController = storyboard.instantiateViewController(withIdentifier: "search") as! SearchResultTableViewController
        searchResultViewController.parentC = self
        searchController = UISearchController.init(searchResultsController: searchResultViewController)
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
        postViewController.request = false
        navigationController?.pushViewController(postViewController, animated: true)
    }

    func fillData(){
        let query = Query()
        query.queryNew(limit: 200,sell:false).observe(.value, with: { snapshot in
            self.items = query.getItems(snapshot: snapshot,sell:false)
            self.tableView.reloadData()
        })
    }
    
    func queryGetItems(searchStr:String){
        let query = Query()
        query.queryBySearchStr(limit: 25, query: searchStr).observe(.value, with: { snapshot in
            let resultController:SearchResultTableViewController = self.searchController?.searchResultsController as! SearchResultTableViewController
            resultController.items = query.getItems(snapshot: snapshot,sell:false)
            resultController.tableView.reloadData()
        })
    }
}

public extension UISearchBar {
    /// Return text field inside a search bar
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    public func setTextFieldBackgroundColor(color: UIColor){
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.backgroundColor = color
    }
}
