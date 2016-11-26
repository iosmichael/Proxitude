//
//  ItemTableViewCell.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(icon:UIImage,title:String,price:String,date:String){
        self.thumbnail.image = icon
        self.itemTitle.text = title
        self.itemPrice.text = price
        self.itemDate.text = date
    }
    
    func setItem(item:Item){
        print(item.name)
        self.itemTitle.text = item.name
        self.itemPrice.text = item.price
        downloadImage(imageURL: item.thumbnail!)
    }
    
    func downloadImage(imageURL:String){
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOf: url as URL) {
                self.thumbnail.image = UIImage.init(data: data as Data)
                self.setNeedsLayout()
            }        
        }
    }
    
}


class TagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tagTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setIconTag(icon:UIImage,tag:String){
        self.icon.image = icon
        self.tagTitle.text = tag
    }
    
}

protocol SelectTagCellProtocol {
    func select(tag: String, isActive:Bool)
}

class SelectTagTableViewCell: UITableViewCell {
    
    let activeColor: UIColor = UIColor.init(hex: "30B0B5")
    let inactiveColor: UIColor = UIColor.init(hex: "525659")
    
    let tagBtn: UIButton = UIButton()
    var tagText: String?
    let percentageXOffset:CGFloat = 0.1
    let topMargin: CGFloat = 5
    let tagBtnHeight:CGFloat = 30
    var isActive: Bool?
    
    var delegate:SelectTagCellProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let contentRect = contentView.bounds
        let btnFrame = CGRect.init(x: contentRect.width * percentageXOffset, y: topMargin , width: contentRect.width * ( 1 - 2 * percentageXOffset ), height: tagBtnHeight)
        tagBtn.frame = btnFrame
        tagBtn.layer.cornerRadius = tagBtnHeight/2
        tagBtn.layer.borderWidth = 1
        tagBtn.layer.borderColor = inactiveColor.cgColor
        tagBtn.setTitleColor(inactiveColor, for: .normal)
        tagBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        contentView.addSubview(tagBtn)
    }
    
    func setText(text:String) {
        tagText = text
        tagBtn.setTitle(text, for: .normal)
        isActive = false
    }
    
    func click(){
        isActive = !isActive!
        if isActive!{
            tagBtn.layer.borderWidth = 0
            tagBtn.backgroundColor = activeColor
            tagBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            tagBtn.backgroundColor = UIColor.white
            tagBtn.layer.borderWidth = 1
            tagBtn.setTitleColor(inactiveColor, for: .normal)
        }
        delegate?.select(tag: tagText!,isActive: isActive!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
