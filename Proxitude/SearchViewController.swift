//
//  SearchViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController?
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
        navigationController?.masterNav()
        addPostBtn()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //update tables correspondingly
        //and update scope
    }
    
    func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagIdentifier)
        tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: itemIdentifier)
        searchController = UISearchController.init(searchResultsController: SearchResultTableViewController())
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.scopeButtonTitles = ["All", "Tags", "Items"]
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
    
    func test(){
        tags.append("Mac")
        items.append("Burrito")
        items.append("Burrito")
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
