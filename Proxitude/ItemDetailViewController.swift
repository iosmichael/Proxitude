//
//  ItemDetailViewController.swift
//  PostDemo
//
//  Created by Michael Liu on 11/24/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import MessageUI

class ItemDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,MFMailComposeViewControllerDelegate{

    var item:Item?
    
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
        setItem()
        setup()
        setupNav()
        registerCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? list.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if images.count == 0 {
                return 0
            }
            return imageCollectionCellHeight
        case 1:
            return CustomTableViewCell.dynamicHeight(label: list[indexPath.row].1, input: list[indexPath.row].2)
        default:
            return 0
        }
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
        tableView.showsVerticalScrollIndicator = false
        fillImages()
    }
    
    func fillImages(){
        for url in (item?.imagesURL)!{
            if let imageURL = URL.init(string: url){
                do {
                    let imageData = try Data.init(contentsOf: imageURL)
                    images.insert(UIImage.init(data: imageData)!, at: images.count)
                } catch {
                    images.insert(UIImage.init(named: "test-item")!, at: 0)
                }
            }else{
                images.insert(UIImage.init(named: "test-item")!, at: 0)
            }
            tableView.reloadData()
        }
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
        let presentImageC = ImagePresenterViewController()
        presentImageC.images = images
        presentImageC.currentPage = indexPath.item
        present(presentImageC, animated: true, completion: nil)
    }

    func setupNav(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(image: UIImage.init(named:"email"),style:.plain, target: self, action: #selector(email))
        let navLeftBtn = UIBarButtonItem.init(image: UIImage.init(named:"backBtn"),style:.plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func back(){
        navigationController?.popViewController(animated: true)
    }
    
    func email(){
        sendEmail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setItem(){
        list = [(cellType.SVLL,"Title",(item?.name)!),
                    (cellType.SVLL,"Price",(item?.price)!),
                    (cellType.SVLL,"Description",(item?.detail)!),
                    (cellType.SVLL,"Email",(item?.user)!)]
        
        for (field,input) in (item?.fields)! {
            list.insert((cellType.SVLL,field,input), at: list.count)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([(item?.user)!])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
