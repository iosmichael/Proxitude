//
//  ImagePresenterViewController.swift
//  Proxitude
//
//  Created by Michael Liu on 11/28/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class ImagePresenterViewController: UIViewController {
    
    var images = [UIImage]()
    var currentPage = 0
    var presenterView: HomePageSlideView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentRect = self.view.frame
        presenterView = HomePageSlideView.init(frame: CGRect.init(x: 0, y: (contentRect.height-contentRect.width)/4, width: contentRect.width, height: contentRect.width))
        self.view.addSubview(presenterView!)
        presenterView?.setupScrollView(images: images, currentPage: currentPage)
        self.view.backgroundColor = UIColor.black
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 5, y: 20, width: 40, height: 40))
        cancelBtn.setImage(UIImage.init(named: "close"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        // Do any additional setup after loading the view.
    }
    
    func close(){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
