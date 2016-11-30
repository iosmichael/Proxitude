//
//  SearchResultTableViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/24/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class SearchResultTableViewController: UITableViewController {

    var items = [Item]()
    let itemIdentifier = "itemCell"
    weak var parentC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.masterNav()
        navigationController?.extendedLayoutIncludesOpaqueBars = true;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getItem(itemId: items[indexPath.row].itemId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: itemIdentifier)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.price
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func getItem(itemId:String){
        FIRDatabase.database().reference().child("colleges/wheaton-college").child("items").child(itemId).observeSingleEvent(of: .value, with: {
            snapshot in
            let item = Item()
            for elem:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "name":
                    item.name = elem.value as! String!
                    break
                case "price":
                    item.price = elem.value as! String!
                    break
                case "detail":
                    item.detail = elem.value as! String!
                    break
                case "user":
                    item.user = elem.value as! String!
                    break
                case "thumbnail":
                    item.thumbnail = elem.value as! String!
                    break
                case "images":
                    for url in elem.value as! [String:String] {
                        item.imagesURL.insert(url.value, at: item.imagesURL.count)
                    }
                    break
                case "date":
                    item.date = elem.value as! String!
                    break
                case "tags":
                    break
                case "sell":
                    item.sell = elem.value as! Bool!
                    break
                default:
                    let tuple = ("\(elem.key)", "\(elem.value!)")
                    item.fields.insert(tuple, at: item.fields.count)
                    break
                }
            }
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let itemDetailController:ItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "itemDetail") as! ItemDetailViewController
            itemDetailController.item = item
            itemDetailController.request = item.sell
            self.parentC?.navigationController?.pushViewController(itemDetailController, animated: true)
        })
    }


}
