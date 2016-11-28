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
    
    var itemId:String!
    var name:String!
    var price:String!
    var detail:String!
    var date: String!
    var thumbnail:String!
    var user:String!
    var uid:String!
    var imagesURL = [String]()
    var sell = true
    
    var fields = [(String,String)]()
    //below for post
    var tags = [String]()
    var images = [UIImage]()
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference().child("wheaton-college")
    var storageRef: FIRStorageReference?
    
    func postData(type:Bool, name:String,price:String,detail:String,tags:[String],images:[UIImage],fields:[(String,String)]){
        self.name = name
        self.price = price
        self.detail = detail
        self.fields = fields
        self.tags = tags
        self.sell = type
        self.images = images
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                self.user = profile.email
                self.uid = profile.uid
            }
        }
        writeItem(user: self.user)
    }
    
    func readData(itemId:String){
        let dataNode = ref?.child("items").value(forKey: itemId)
        print("\(dataNode)")
    }
    
    func writeItem(user:String){
        storageRef = FIRStorage.storage().reference(forURL: storageURL)
        let itemsNode = ref?.child("items").childByAutoId()
        let usersNode = ref?.child("users").child(uid).child("items").childByAutoId()
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if let error = error {
                print(error)
            }
        }
        let autoId = itemsNode?.key
        usersNode?.setValue(autoId)
        if sell{
            for i in 0...images.count-1{
                //let data = UIImageJPEGRepresentation(images[i], 0.8)
                let data = UIImageJPEGRepresentation(images[i], 0.8)
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
        }
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dateString: String = currentDate.convertDateToString()
        var posts = ["name":name!, "price":price!, "detail":detail!, "user":user, "date":dateString, "sell":sell] as [String : Any]
        for (field, input) in fields{
            posts[field] = input
            print("\(field):\(input)")
        }
        print("post data here: ------>\(posts)")
        itemsNode?.updateChildValues(posts)
        for tag in tags{
            //category links
            itemsNode?.child("tags").child(tag).setValue(1)
        }
    }
    
    func save(itemID:String,user:String){
        ref?.child("users").child(user).child("saves").childByAutoId().setValue(itemID)
    }
    
    func deleteItem(itemID:String){
        let itemsNode = ref?.child("items").child(itemID)
        itemsNode?.removeValue()
    }
    
    
}

extension Date{
    func convertDateToString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func convertStringToDate(date:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)!
    }
}
