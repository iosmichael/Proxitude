//
//  ImagesTableViewCell.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
    
    let imageCollectionIdentifier = "images"
    
    class imageView:UICollectionView{
        var indexPath:NSIndexPath?
    }

    var collectionView: imageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        collectionView?.frame = contentView.bounds
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.itemSize = CGSize.init(width: 90, height: 90)
        layout.scrollDirection = .horizontal
        collectionView = imageView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: imageCollectionIdentifier)
        collectionView?.backgroundColor = UIColor.init(hex: "525659")
        contentView.addSubview(collectionView!)
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: (AnyObject), indexPath:NSIndexPath){
        collectionView?.dataSource = dataSourceDelegate as? UICollectionViewDataSource
        collectionView?.delegate = dataSourceDelegate as? UICollectionViewDelegate
        collectionView?.indexPath = indexPath
        collectionView?.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
