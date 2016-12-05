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
    let tagList = ["BITH","HUMANITIES","SCIENCES","LANGUAGES","OTHER"]
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
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference().child("colleges/wheaton-college")
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
                writeItem(user: self.user)
            }
        }
    }
    
    func readData(itemId:String){
        let dataNode = ref?.child("items").value(forKey: itemId)
        print("\(dataNode)")
    }
    
    func writeItem(user:String){
        storageRef = FIRStorage.storage().reference(forURL: storageURL)
        let itemsNode = ref?.child("items").childByAutoId()
        let tagsNode = ref?.child("tags")
        
        let autoId = itemsNode?.key
        
        if sell{
            let screenWidth = UIScreen.main.bounds.width
            let sqrThumbnailImage = UIImage.cropToBounds(image: images[0], width: Double(screenWidth), height: Double(screenWidth))
            let thumbnailImg = sqrThumbnailImage.resizeWith(width: 70)
            let thumbnailData = UIImageJPEGRepresentation(thumbnailImg!, 0.2)
            let thumbnailRef = storageRef?.child("images/\(autoId)-image-thumbnail.jpg")
            let thumbMetaData = FIRStorageMetadata()
            thumbMetaData.contentType = "image/jpg"
            thumbnailRef?.put(thumbnailData!, metadata: thumbMetaData){ metadata, error in
                if (error != nil) {
                    print(error!)
                    // Uh-oh, an error occurred!
                }
                let downloadURL:String = (metadata!.downloadURL()?.absoluteString)!
                itemsNode?.child("thumbnail").setValue("\(downloadURL)")
            }
            
            for i in 0...images.count-1{
                let sqrImage = UIImage.cropToBounds(image: images[i], width: Double(screenWidth), height: Double(screenWidth))
                let smImage = sqrImage.resizeWith(width: screenWidth)
                let data = UIImageJPEGRepresentation(smImage!, 0.5)
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
                    itemsNode?.child("images/image-\(i)").setValue("\(downloadURL)")
                }
            }
        }
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dateString: String = currentDate.convertDateToString()
        if price == nil{
            price = ""
        }
        var posts = ["name":name!, "price":price!, "detail":detail!, "user":user, "date":dateString, "sell":sell] as [String : Any]
        for (field, input) in fields{
            posts[field] = input
            print("\(field):\(input)")
        }
        print("post data here: ------>\(posts)")
        itemsNode?.updateChildValues(posts)
        for tag in tags{
            //category links
            tagsNode?.child(tag).child(autoId!).setValue(1)
        }
    }
    
    func deleteItem(itemID:String){
        let itemsNode = ref?.child("items").child(itemID)
        itemsNode?.removeValue()
        
        for tag in tagList {
            //need query here!
            ref?.child("tags").child(tag).child(itemID).removeValue()
        }
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


extension UIImage{
    
    public func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    class func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage.init(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        let rect: CGRect = CGRect.init(x: posX, y: posY, width: cgwidth, height: cgheight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
}
