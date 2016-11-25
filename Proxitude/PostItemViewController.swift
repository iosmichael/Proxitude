//
//  PostItemViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/23/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox


class PostItemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomCellProtocol,UICollectionViewDataSource,UICollectionViewDelegate,ImagePickerDelegate{

    let imageCollectionIdentifier = "images"
    let imageLimits = 5
    let imageCollectionCellHeight:CGFloat = 100
    let customListCellHeight:CGFloat = 44
    var images = [UIImage]()
    
    enum cellType {
        case LL
        case LI
        case CII
        case CLL
    }
    var list = [(cellType.LI,"Title","Item Title"),
                (cellType.LI,"Price","Item Price"),
                (cellType.LL,"Detail",""),
                (cellType.LL,"Tags",""),
                (cellType.CII,"Field","Value"),
                (cellType.CLL,"Weight","3 lbs")]
    
    @IBOutlet weak var tableview: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addPhotoBtn()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .singleLineEtched
        tableview.separatorColor = UIColor.lightGray
        registerCell()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1: list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ImagesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagesTableViewCell
            return cell
        }else{
            let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! CustomTableViewCell
            cell.delegate = self
            let (type,L1,L2) = list[indexPath.row]
            fill(cell: cell,type: type,L1: L1,L2: L2)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? imageCollectionCellHeight: customListCellHeight
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
        //show image picker
        if indexPath.item == images.count - 1 {
            presentImagePicker()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionIdentifier, for: indexPath)
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        imageView.image = images[indexPath.item]
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        cell.contentView.addSubview(imageView)
        if indexPath.item != images.count-1{
            let deleteBtn = UIButton.init(frame: CGRect.init(x: 65, y: 3, width: 22, height: 22))
            deleteBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
            deleteBtn.tag = indexPath.item
            deleteBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
            cell.contentView.addSubview(deleteBtn)
        }
        return cell
    }
    
    func registerCell(){
        tableview.register(CustomTableViewCell.self, forCellReuseIdentifier: "ListCell")
        tableview.register(ImagesTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    func setup(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(image: UIImage.init(named:"check"),style:.plain, target: self, action: #selector(submit))
        let navLeftBtn = UIBarButtonItem.init(image: UIImage.init(named: "close"), style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func cancel(){
        print("cancel")
    }
    
    func submit(){
        print("submit")
    }
    
    func addBtn(label:String, input:String){
        //add new field
        print("add item \(label) : \(input) ")
        list.insert((cellType.CLL,label,input), at: list.count)
        self.tableview.reloadData()
    }
    
    func deleteBtn(cell:CustomTableViewCell){
        var indexPath = tableview.indexPath(for: cell)
        list.remove(at: (indexPath?.row)!)
        self.tableview.reloadData()
    }
    
    func deleteImage(sender: UIButton){
        images.remove(at: sender.tag)
        sender.removeFromSuperview()
        tableview.reloadData()
    }
    
    func fill(cell:CustomTableViewCell,type:cellType, L1:String, L2:String){
        switch type {
        case .LL:
            cell.fillLL(labelStr: L1, inputStr: L2)
            break;
        case .LI:
            cell.fillLI(labelStr: L1, inputStr: L2)
            break;
        case .CLL:
            cell.fillCLL(labelStr: L1, inputStr: L2)
            break;
        case .CII:
            cell.fillCII(labelStr: L1, inputStr: L2)
            break;
        }
    }
    
    func addPhotoBtn(){
        images.insert(UIImage.init(named: "photo")!, at: images.count)
    }
    
    // MARK: - ImagePickerDelegate
    
    func presentImagePicker(){
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = imageLimits-images.count
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        for image in images{
            self.images.insert(image, at: 0)
        }
        tableview.reloadData()
    }

    
}

