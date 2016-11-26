//
//  Item.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class Item: NSObject {
    let storageURL = "gs://dazzling-fire-5565.appspot.com"
    let username = "michael.liu@my.wheaton.edu"
    
    var name:String?
    var price:String?
    var detail:String?
    var fields = [(String,String)]()
    var tags = [String]()
    var images = [UIImage]()
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference().child("wheaton-college")
    var storageRef: FIRStorageReference?
    
    func postData(name:String,price:String,detail:String,tags:[String],images:[UIImage],fields:[(String,String)]){
        self.name = name
        self.price = price
        self.detail = detail
        self.fields = fields
        self.tags = tags
        self.images = images
        writeItem()
    }
    
    func readData(itemId:String){
        let dataNode = ref?.child("items").value(forKey: itemId)
        print("\(dataNode)")
    }
    
    func writeItem(){
        storageRef = FIRStorage.storage().reference(forURL: storageURL)
        let itemsNode = ref?.child("items").childByAutoId()
        let usersNode = ref?.child("users").child(username).child("items").childByAutoId()
        let categoriesNode = ref?.child("tags")
        
        let autoId = itemsNode?.key
        usersNode?.setValue(autoId)
        var imagesURL = [String]()
        for i in 0...images.count-1{
            let data = UIImageJPEGRepresentation(images[i], 0.5)
            let picRef = storageRef?.child("\(autoId)-image-\(i).jpg")
            picRef?.put(data!, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    imagesURL.insert("\(metadata!.downloadURL)", at: 0)
                }
            }
        }
        
        var posts = ["name":name!, "price":price!, "detail":detail!, "user":username, "images":imagesURL] as [String : Any]
        for (field, input) in fields{
            posts[field] = input
        }
        itemsNode?.setValue(posts)
        
        for tag in tags{
            //category links
            categoriesNode?.child(tag).childByAutoId().setValue(autoId)
        }
        
    }
    
    func save(itemID:String){
        ref?.child("users").child(username).child("saves").childByAutoId().setValue(itemID)
    }
    
    
}
