//
//  CustomTableViewCell.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

protocol CustomCellProtocol {
    func addBtn(label:String, input:String)
    func deleteBtn(cell:CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    let leftMargin:CGFloat = 15
    let topMargin:CGFloat = 5
    let rightMargin:CGFloat = 10
    let cRightMargin:CGFloat = 50
    let topBottomGap:CGFloat = 5
    let leftWidth:CGFloat = 75
    let systemFont = UIFont.systemFont(ofSize: 15)
    let italicSystemFont = UIFont.italicSystemFont(ofSize: 12)
    
    var leftFrame:CGRect = CGRect()
    var rightFrame:CGRect = CGRect()
    var cRightFrame:CGRect = CGRect()
    
    var delegate:CustomCellProtocol?
    
    var leftLabel:UILabel = UILabel()
    var leftInput:UITextField = UITextField()
    var rightLabel:UILabel = UILabel()
    var rightInput:UITextField = UITextField()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let height = contentView.bounds.height
        let width = UIScreen.main.bounds.width
        leftFrame = CGRect.init(x: leftMargin, y: topMargin, width: leftWidth, height: height-2*topMargin)
        rightFrame = CGRect.init(x: 2*leftMargin+leftWidth, y: topMargin, width: width-2*leftMargin-leftWidth-rightMargin, height: height-2*topMargin)
        cRightFrame = CGRect.init(x: 2*leftMargin+leftWidth, y: topMargin, width: width-2*leftMargin-leftWidth-cRightMargin, height: height-2*topMargin)
        selectionStyle = .none
        contentView.addSubview(leftLabel)
        contentView.addSubview(leftInput)
        contentView.addSubview(rightLabel)
        contentView.addSubview(rightInput)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillSVLL(labelStr:String, inputStr:String){
        let width = UIScreen.main.bounds.width
        let horizontalWidth = width-leftMargin-rightMargin
        let textHeight: CGFloat = inputStr.heightWithConstrainedWidth(width: horizontalWidth, font: systemFont)
        let labelHeight: CGFloat = labelStr.heightWithConstrainedWidth(width: horizontalWidth, font: systemFont)
        let topFrame: CGRect = CGRect.init(x: leftMargin, y: topMargin, width: horizontalWidth, height: labelHeight)
        let bottomFrame: CGRect = CGRect.init(x: leftMargin, y: topMargin+topFrame.height+topBottomGap, width: horizontalWidth, height: textHeight)
        leftLabel.frame = topFrame
        rightLabel.frame = bottomFrame
        leftLabel.text = labelStr
        rightLabel.text = inputStr
        leftLabel.font = italicSystemFont
        rightLabel.font = systemFont
        rightLabel.numberOfLines = 0
        rightLabel.lineBreakMode = .byWordWrapping
        leftLabel.textColor = UIColor.lightGray
        rightLabel.textColor = UIColor.darkGray
        setNeedsLayout()
    }
    
    func fillLL(labelStr:String, inputStr:String){
        leftLabel.frame = leftFrame
        rightLabel.frame = cRightFrame
        leftLabel.text = labelStr
        rightLabel.text = inputStr
        leftLabel.font = systemFont
        rightLabel.font = systemFont
        accessoryType = .disclosureIndicator
        setNeedsLayout()
    }
    
    func fillLI(labelStr:String, inputStr:String){
        leftLabel.frame = leftFrame
        rightInput.frame = rightFrame
        leftLabel.text = labelStr
        rightInput.placeholder = inputStr
        leftLabel.font = systemFont
        rightInput.font = systemFont
        setNeedsLayout()
    }
    
    func fillCII(labelStr: String, inputStr:String){
        leftInput.frame = leftFrame
        rightInput.frame = cRightFrame
        leftInput.text = ""
        rightInput.text = ""
        let btn = UIButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 25, height: 25)))
        btn.setImage(UIImage.init(named: "add"), for: .normal)
        btn.addTarget(self, action: #selector(CustomTableViewCell.addClick), for: .touchUpInside)
        accessoryView = btn
        leftInput.placeholder = labelStr
        rightInput.placeholder = inputStr
        leftInput.font = systemFont
        rightInput.font = systemFont
        setNeedsLayout()
    }
    
    func fillCLL(labelStr: String, inputStr:String){
        leftLabel.frame = leftFrame
        rightLabel.frame = cRightFrame
        let btn = UIButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 25, height: 25)))
        btn.setImage(UIImage.init(named: "delete"), for: .normal)
        btn.addTarget(self, action: #selector(CustomTableViewCell.deleteClick), for: .touchUpInside)
        accessoryView = btn
        leftLabel.text = labelStr
        rightLabel.text = inputStr
        leftLabel.font = systemFont
        rightLabel.font = systemFont
        setNeedsLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addClick(){
        if (leftInput.text?.isEmpty)! && (rightInput.text?.isEmpty)!{
            return
        }
        delegate?.addBtn(label:leftInput.text!, input:rightInput.text!)
    }
    func deleteClick(){
        delegate?.deleteBtn(cell: self)
    }
    
    public static func dynamicHeight(label: String, input:String)->CGFloat{
        let width = UIScreen.main.bounds.width
        let horizontalWidth = width-25
        let systemFont = UIFont.systemFont(ofSize: 15)
        let italicSystemFont = UIFont.italicSystemFont(ofSize: 12)
        let textHeight: CGFloat = input.heightWithConstrainedWidth(width: horizontalWidth, font: italicSystemFont)
        let labelHeight: CGFloat = label.heightWithConstrainedWidth(width: horizontalWidth, font: systemFont)
        return textHeight+labelHeight+10+5
    }

}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
