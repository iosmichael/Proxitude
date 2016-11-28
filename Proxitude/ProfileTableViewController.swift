//
//  ProfileTableViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    let tagCellIdentifier = "tagCell"
    let contactCellIdentifier = "contactCell"
    let loginIdentifier = "loginCell"
    let tagCellHeight: CGFloat = 37
    let contactCellHeight: CGFloat = 70
    var isLogged:Bool?
    var list = [(UIImage,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.masterNav()
        addPostBtn()
        setup()
        fillData()
        let user = FIRAuth.auth()?.currentUser
        isLogged = user != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = FIRAuth.auth()?.currentUser
        isLogged = user != nil
        tableView.reloadData()
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
            if isLogged!{
                let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as! ProfileTableViewCell
                if let user = FIRAuth.auth()?.currentUser {
                    for profile in user.providerData {
                        let name = profile.displayName
                        let email = profile.email
                        cell.setupCell(username: (name)!, email: (email)!)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: loginIdentifier, for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell:TagTableViewCell = tableView.dequeueReusableCell(withIdentifier: tagCellIdentifier, for: indexPath) as! TagTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.setIconTag(icon: list[indexPath.row].0, tag: list[indexPath.row].1)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if isLogged!{
                signOut()
                isLogged = false
                tableView.reloadData()
            }else{
                let loginViewController = LogInViewController.init(nibName: "LogInViewController", bundle: nil)
                present(loginViewController, animated: true, completion: nil)
            }
        }else{
            switch indexPath.row {
            case 0:
                //myItems
                let categoryController = CategoryTableViewController()
                categoryController.queryType = .myItem
                navigationController?.pushViewController(categoryController, animated: true)
                break
            case 1:
                //About
                let url = URL.init(string: "https://www.facebook.com/proximarketplace/")
                UIApplication.shared.openURL(url!)
                break
            case 2:
                //Report a Problem
                let url = URL.init(string: "https://twitter.com/proxiwheaton")
                UIApplication.shared.openURL(url!)
                break
            default:
                break
            }
        }
    }

    func setup(){
        tableView.register(UINib.init(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: tagCellIdentifier)
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellIdentifier)
        tableView.register(UINib.init(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: loginIdentifier)
    }
    
    func fillData(){
//        list.insert((UIImage.init(named: "login")!,"Test-Login-Page"), at: 0)
        list.insert((UIImage.init(named: "report")!,"Report a Problem :P"), at: 0)
        list.insert((UIImage.init(named: "facebook")!,"About"), at: 0)
//        list.insert((UIImage.init(named: "message")!,"Messages"), at: 0)
//        list.insert((UIImage.init(named: "scanner")!,"QR Scanner"), at: 0)
        list.insert((UIImage.init(named: "myItem")!,"My Items"), at: 0)
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
        let postViewController = storyboard.instantiateViewController(withIdentifier: "post")
        navigationController?.pushViewController(postViewController, animated: true)
    }

    func signOut(){
        try! FIRAuth.auth()!.signOut()
        GIDSignIn.sharedInstance().signOut()
    }
   
}
