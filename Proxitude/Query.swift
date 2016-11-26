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
    
    var itemRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        itemRef = FIRDatabase.database().reference().child("wheaton-college/items")
    }
    
    func queryRecommended(limit:Int)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    //items snapshot
    public func getItems(snapshot:FIRDataSnapshot)->[Item]{
        var items = [Item]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let item = Item()
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
                default:
                    let tuple = ("\(elem.key)", "\(elem.value!)")
                    item.fields.insert(tuple, at: item.fields.count)
                    break
                }
            }
            print("fields: \(item.fields), imagesURL: \(item.imagesURL), name: \(item.name)")
            items.insert(item, at: items.count)
        }
        
        return items
    }
    
}
