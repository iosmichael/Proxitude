//
//  ItemTableViewCell.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class TagTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
