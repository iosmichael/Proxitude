//
//  Contact.swift
//  Proxitude
//
//  Created by Michael Liu on 11/26/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class Contact: NSObject {
    var image: UIImage?
    var fullName: String?
    var email: String?
    var uid: String?
    var ref: FIRDatabaseReference?
    
    override init() {
        super.init()
        ref = FIRDatabase.database().reference().child("wheaton-college")
    }
    
    func getItems(uid:String)->[Item]{
        var items = [Item]()
        
        return items
    }
    
    func getMyItems(uid:String)->[Item]{
        var items = [Item]()
        
        return items
    }
    
    func getMySaves(uid:String)->[Item]{
        var items = [Item]()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref?.child("users").child(userID!).child("saves").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String : AnyObject]
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        return items
    }
    
}
