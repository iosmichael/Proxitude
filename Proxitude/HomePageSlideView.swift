//
//  HomePageSlideView.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit

class HomePageSlideView: UIView, UIScrollViewDelegate {

    var scrollView: UIScrollView?
    var pageIndex: UIPageControl?
    
    var images = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPageIndex(currentPage: Int){
        pageIndex = UIPageControl.init(frame: CGRect.init(x: 0, y: (scrollView?.frame.size.height)!*0.8, width: (scrollView?.frame.size.width)!/2, height: 20))
        pageIndex?.tintColor = UIColor.gray
        pageIndex?.currentPageIndicatorTintColor = UIColor.white
        pageIndex?.currentPage = 0
        addSubview(scrollView!)
        addSubview(pageIndex!)
        pageIndex?.numberOfPages = images.count
    }
    
    func setupScrollView(images: [UIImage], currentPage: Int){
        scrollView = UIScrollView.init(frame: frame)
        scrollView?.contentSize = CGSize.init(width: frame.size.width * CGFloat(images.count), height: 0)
        for i:Int in 0...images.count-1{
            var image: UIImage?
            if i > images.count - 1 {
                image = UIImage.init(named: "banner")
            }else{
                image = images[i]
            }
            let imageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0 + frame.size.width * CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height))
            imageView.image = image
            scrollView?.addSubview(imageView)
        }
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.isScrollEnabled = true
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        scrollView?.bounces = false
        scrollView?.delegate = self;
        setupPageIndex(currentPage: currentPage)
    }
    
    func changePage(){
        let pageWidth = scrollView?.frame.size.width
        if pageIndex?.currentPage ==  images.count - 1 {
            pageIndex?.currentPage = 0
            scrollView?.setContentOffset(CGPoint.zero, animated: true)
        }else{
            pageIndex?.currentPage += 1
            let newX = (scrollView?.contentOffset.x)! + pageWidth!
            scrollView?.setContentOffset(CGPoint.init(x: newX, y: 0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page: Int = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth))+1
        pageIndex?.currentPage = page
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
