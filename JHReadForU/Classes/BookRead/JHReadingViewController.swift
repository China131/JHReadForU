//
//  JHReadingViewController.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/12/2.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHReadingViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    
    
    
    var model:BookModel?
    var currentIndex:Int?
    var cacheArray:[RBViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        self.fd_interactivePopDisabled = true
        self.view.backgroundColor = UIColor.white
        BookReadRecoder.defaultRecord.bookName = model?.book_name
        BookReadRecoder.defaultRecord.bookID = model?.bookID
        BookReadRecoder.defaultRecord.cacheCurrentContent()
        currentIndex = 0
        cacheArray = Array.init()
        
        for index in 0...2 {
            let RB = RBViewController.init()
            
            cacheArray!.append(RB)
        }
        
        self.setViewControllers([cacheArray![0]], direction: .forward, animated: true) { (finish) in
            
            
        }
        self.dataSource = self
        self.delegate = self
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pageViewController.view.isUserInteractionEnabled = false
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if finished {
            pageViewController.view.isUserInteractionEnabled = true
        }else{
            pageViewController.view.isUserInteractionEnabled = false
        }
        
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if pageViewController.view.isUserInteractionEnabled {
            
        }else{
            return nil
        }
        
        let nextVC = nextRBViewController(currentRB: viewController as! RBViewController)
        return nextVC
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if pageViewController.view.isUserInteractionEnabled {
            
        }else{
            return nil
        }
        
        let nextVC = nextRBViewController(currentRB: viewController as! RBViewController)
        return nextVC
    }
    
    
    func nextRBViewController(currentRB:RBViewController) -> RBViewController {
        
        print(BookReadRecoder.defaultRecord.nextLength())
        if currentRB == cacheArray![0] {
            return cacheArray![1]
        }else{
            return cacheArray![0]
        }
    }
    
    
    
    
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
