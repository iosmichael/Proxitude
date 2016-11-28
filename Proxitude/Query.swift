//
//  Query.swift
//  Proxitude
//
//  Created by Michael Liu on 11/26/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class Query: NSObject {
    
    var userRef:FIRDatabaseReference?
    var itemRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        itemRef = FIRDatabase.database().reference().child("wheaton-college/items")
        userRef = FIRDatabase.database().reference().child("wheaton-college/users")
    }
    
    func queryNew(limit:Int,sell:Bool)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "sell").queryEqual(toValue: sell))!
    }
    
    func queryByCategory(limit:Int,category:String)->FIRDatabaseQuery{
        return (itemRef?.queryOrdered(byChild: "tags/\(category)").queryEqual(toValue: "1").queryLimited(toLast: UInt(limit)))!
    }
    
    func queryItemByUser(user:String)->FIRDatabaseQuery{
        return (itemRef?.queryOrdered(byChild: "user").queryEqual(toValue: user))!
    }
    
    func queryBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "title").queryStarting(atValue: query))!
    }
    
    
    
    func getUser(uid:String)->Contact{
        let user = Contact()
        user.uid = uid
        userRef?.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                switch child.key{
                case "fullName":
                    user.fullName = child.value as! String!
                break
                case "email":
                    user.fullName = child.value as! String!
                break
                default:
                    break
                }
            }
        })
        return user
    }
    
    //items snapshot
    public func getItems(snapshot:FIRDataSnapshot)->[Item]{
        var items = [Item]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let item = Item()
            item.itemId = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
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
                case  "date":
                    item.date = elem.value as! String!
                break
                case "tags":
                break
                case "sell":
                break
                default:
                    let tuple = ("\(elem.key)", "\(elem.value!)")
                    item.fields.insert(tuple, at: item.fields.count)
                    break
                }
            }
            print("fields: \(item.fields), imagesURL: \(item.imagesURL), name: \(item.name)")
            items.insert(item, at: 0)
        }
        return items
    }
    
    //use itemID to fetch Item Object
    func getItem(itemId:String) -> Item {
        let item = Item()
        itemRef?.child(itemId).observe(.value, with: {
            snapshot in
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
                    break
                default:
                    let tuple = ("\(elem.key)", "\(elem.value!)")
                    item.fields.insert(tuple, at: item.fields.count)
                    break
                }
            }
        })
        item.itemId = itemId
        return item
    }
    
}
