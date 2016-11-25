//
//  ItemDetailViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/24/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate{

    let imageCollectionIdentifier = "images"
    let imageCellIdentifier = "imageCell"
    let customCellIdentifier = "listCell"
    var images = [UIImage]()
    
    let imageCollectionCellHeight:CGFloat = 100
    let customListCellHeight:CGFloat = 44
    
    enum cellType {
        case SVLL
        case LL
        case LI
        case CII
        case CLL
    }
    
    var list = [(cellType.SVLL,"Title","Item Title"),
                (cellType.SVLL,"Price","Item Price"),
                (cellType.SVLL,"Description","skdjfklasjdflasdflkjsadlkfjlksadjflasjdflk"),
                (cellType.SVLL,"Size","12sz"),
                (cellType.SVLL,"Weight","3 lbs"),
                (cellType.SVLL,"Professor","Dr. Decort"),
                (cellType.SVLL,"Class","Introduction to Philosophy")]
    let detailPos = 2
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? imageCollectionCellHeight : CustomTableViewCell.dynamicHeight(label: list[indexPath.row].1, input: list[indexPath.row].2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:ImagesTableViewCell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier) as! ImagesTableViewCell
            return cell
        }else{
            let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier) as! CustomTableViewCell
            let (type,L1,L2) = list[indexPath.row]
            fill(cell: cell,type: type,L1: L1,L2: L2)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isKind(of: ImagesTableViewCell.self){
            let imageCell = cell as! ImagesTableViewCell
            imageCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, indexPath: indexPath as NSIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentImagePicker(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionIdentifier, for: indexPath)
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        imageView.image = images[indexPath.item]
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func registerCell(){
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: customCellIdentifier)
        tableView.register(ImagesTableViewCell.self, forCellReuseIdentifier: imageCellIdentifier)
        tableView.separatorStyle = .none
    }
    
    func setup(){
        tableView.delegate = self
        tableView.dataSource = self
        fillImages()
    }
    
    func fillImages(){
        images.insert(UIImage.init(named: "test-item")!, at: 0)
        images.insert(UIImage.init(named: "test-item")!, at: 0)
        images.insert(UIImage.init(named: "test-item")!, at: 0)
        images.insert(UIImage.init(named: "test-item")!, at: 0)
        images.insert(UIImage.init(named: "test-item")!, at: 0)
    }
    
    
    func fill(cell:CustomTableViewCell,type:cellType, L1:String, L2:String){
        switch type {
        case .LL:
            cell.fillLL(labelStr: L1, inputStr: L2)
            break
        case .LI:
            cell.fillLI(labelStr: L1, inputStr: L2)
            break
        case .CLL:
            cell.fillCLL(labelStr: L1, inputStr: L2)
            break
        case .CII:
            cell.fillCII(labelStr: L1, inputStr: L2)
            break
        case.SVLL:
            cell.fillSVLL(labelStr: L1, inputStr: L2)
            break
        }
    }
    
    func presentImagePicker(indexPath:IndexPath){
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
