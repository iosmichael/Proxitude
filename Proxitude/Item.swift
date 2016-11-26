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
    let username = "michaelliu@mywheatonedu"
    
    var name:String!
    var price:String!
    var detail:String!
    var thumbnail:String!
    var user:String!
    var imagesURL = [String]()
    
    var fields = [(String,String)]()
    //below for post
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
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if let error = error {
                print(error)
            }
        }
        let autoId = itemsNode?.key
        usersNode?.setValue(autoId)
        for i in 0...images.count-1{
            //let data = UIImageJPEGRepresentation(images[i], 0.8)
            let data = UIImageJPEGRepresentation(UIImage.init(named: "pic")!, 0.8)
            let picRef = storageRef?.child("images/\(autoId)-image-\(i).jpg")
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            picRef?.put(data!, metadata: metaData) { metadata, error in
                if (error != nil) {
                    print(error!)
                    // Uh-oh, an error occurred!
                }
                let downloadURL:String = (metadata!.downloadURL()?.absoluteString)!
                    // Metadata contains file metadata such as size, content-type, and download URL.
                if i == 0 {
                    itemsNode?.child("thumbnail").setValue("\(downloadURL)")
                }
                itemsNode?.child("images/image-\(i)").setValue("\(downloadURL)")
            }
        }
        
        //#warning - Need dates! here!
        
        var posts = ["name":name!, "price":price!, "detail":detail!, "user":username] as [String : Any]
        for (field, input) in fields{
            posts[field] = input
        }
        print("post data here: ------>\(posts)")
        itemsNode?.updateChildValues(posts)
        
        for tag in tags{
            //category links
            categoriesNode?.child(tag).childByAutoId().setValue(autoId)
        }
        
    }
    
    func save(itemID:String){
        ref?.child("users").child(username).child("saves").childByAutoId().setValue(itemID)
    }
    
    
}
