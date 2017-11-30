//
//  JHBaseViewController.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/8.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = JHBaseBackGroundColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    

    func baseBackClick() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    public func setTitleWithString(title:String)->Void{
        
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20))
        lab.text = title
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textAlignment = .center
        self.navigationItem.titleView = lab
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect.init(x: -10, y: 0, width: 55, height: 40)
        backBtn.setImage(UIImage.init(named: "返回"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        backBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
        backBtn.setTitle("返回", for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.addTarget(self, action: #selector(JHBaseViewController.baseBackClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    public func backClick() -> Void {
        weak var mainVC = self.rootNavigationController().viewControllers[0] as!JHMainViewController
        mainVC?.scrollView?.setContentOffset(CGPoint.init(x: UISCREEN_WIDTH-100, y: 0), animated: true)
    }
    
    
    
    
    public func setTabBarControllerNavigationTitle(title:String)->Void{
        var bgView:UIView = UIView.init(frame: CGRect.init())
        bgView.backgroundColor = JHBaseLightGrayColor
        self.view.addSubview(bgView)
        
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 40))
        lab.text = title
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        bgView.addSubview(lab)
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect.init(x: -10, y: 0, width: 55, height: 40)
        backBtn.setImage(UIImage.init(named: "返回"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        backBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
        backBtn.setTitle("返回", for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.addTarget(self, action: #selector(JHBaseViewController.backClick), for: .touchUpInside)
        bgView.addSubview(backBtn)
        
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.setImage(UIImage.init(named: "搜索"), for: .normal)
        searchBtn.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        bgView.addSubview(searchBtn)
        
        weak var weakSelf = self
        bgView.mas_makeConstraints { (make) in
            
           _ = make?.top.left().right().equalTo()(weakSelf?.view)
           _ = make?.height.mas_equalTo()(64)
            
        }
        
        lab.mas_makeConstraints { (make) in
            _ = make?.centerX.equalTo()(bgView.mas_centerX)
            _ = make?.bottom.equalTo()(bgView.mas_bottom)?.offset()(-15)
        }
        
        backBtn.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(bgView.mas_left)?.offset()(20)
            _ = make?.centerY.equalTo()(lab.mas_centerY)
            _ = make?.height.mas_equalTo()(40)
        }
        
        searchBtn.mas_makeConstraints { (make) in
            _ = make?.right.equalTo()(bgView.mas_right)?.offset()(-15)
            _ = make?.centerY.equalTo()(lab.mas_centerY)
            _ = make?.height.width().mas_equalTo()(20)
        }
        

        
    }
    
    
    public func rootNavigationController()->UINavigationController{
        
        return (UIApplication.shared.delegate as! AppDelegate).navigationVC!;
    }

    deinit {
        print(self.classForCoder)
    }

}
