//
//  InputFormCell.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class InputFormCell: UITableViewCell {
    let leftMargin: CGFloat! = 10
    let topMargin:CGFloat! = 8
    let labelWidth:CGFloat! = 75
    
    var inputfield = UITextField()
    var label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let cellBounds = self.contentView.bounds
        let labelHeight = cellBounds.height-2*topMargin
        let inputOffset = (2*leftMargin+labelWidth)
        let inputWidth = cellBounds.width - inputOffset - leftMargin
        label.bounds = CGRect.init(x: leftMargin, y: topMargin, width: labelWidth, height: labelHeight)
        label.text = "Title"
        inputfield.bounds = CGRect.init(x: inputOffset, y: topMargin, width: inputWidth, height: labelHeight)
        inputfield.borderStyle = UITextBorderStyle.none
        inputfield.placeholder = "Title"
        contentView.addSubview(label)
        contentView.addSubview(inputfield)
    }
    
    public func config(text:String?, placeholder:String){
        inputfield.text = text
        inputfield.placeholder = placeholder
        inputfield.accessibilityValue = text
        inputfield.accessibilityLabel = placeholder
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
