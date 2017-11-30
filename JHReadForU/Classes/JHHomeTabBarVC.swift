//
//  JHHomeTabBarVC.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/15.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHHomeTabBarVC: UITabBarController {


    func configBaseView() -> Void {
        self.view.backgroundColor = UIColor.white
        var cacheArray:[JHBaseViewController] = Array.init()
        var VCArray = ["JHReadForU.JHRecommendVC","JHReadForU.JHBookSourceVC","JHReadForU.JHActiviryVC"]
        var iconArray:[String] = ["皇冠","书本","朋友圈"]
        var selectIconArray = ["皇冠-2","书本-2","朋友圈-2"]
        var titleArray = ["精选","书库","圈子"]
        
        for i in 0..<VCArray.count{
            let className = VCArray[i]
            let vc = (NSClassFromString(className) as! JHBaseViewController.Type).init()
            vc.view.backgroundColor = JHBaseBackGroundColor
            var image = UIImage.init(named: iconArray[i])
            image = image?.withRenderingMode(.alwaysOriginal)
            
            var selectImage = UIImage.init(named: selectIconArray[i])
            selectImage = selectImage?.withRenderingMode(.alwaysOriginal)
            
            let tabItems = UITabBarItem.init(title: titleArray[i], image: image, selectedImage: selectImage)
            tabItems.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.lightGray], for: .normal)
            tabItems.setTitleTextAttributes([NSForegroundColorAttributeName:JHColor(r: 31, g: 222, b: 216, a: 1)], for: .selected)
            vc.tabBarItem = tabItems
            
            cacheArray.append(vc)
            
            
        }
        self.setViewControllers(cacheArray, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
