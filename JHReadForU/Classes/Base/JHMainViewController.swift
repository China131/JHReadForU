//
//  JHMainViewController.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/8.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import Masonry
class JHMainViewController: JHBaseViewController,UIScrollViewDelegate,CAAnimationDelegate {
    var tabBarChildVC: JHHomeTabBarVC?
    var scrollView:UIScrollView?
    var leftMeumView:MainLeftMeumView?
    var mainView:MainHomeView?
    var animationImageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        scrollView = UIScrollView()
        self.view.addSubview(scrollView!)
        
        tabBarChildVC = JHHomeTabBarVC()
        scrollView!.addSubview(tabBarChildVC!.view)
        self.addChildViewController(tabBarChildVC!)
        
        leftMeumView = MainLeftMeumView.init(frame: CGRect.init())
        scrollView!.addSubview(leftMeumView!)
        
        mainView = MainHomeView.init(frame: CGRect.init())
        mainView?.backgroundColor = UIColor.white
        scrollView!.addSubview(mainView!)
        weak var weakSelf = self
        
        _ = scrollView?.mas_makeConstraints({ (make)->Void in
           _ = make?.top.left().right().bottom().equalTo()(weakSelf?.view)
        })
        
        
        _ = leftMeumView!.mas_makeConstraints({ (make) in
            _ = make?.leading.equalTo()(weakSelf?.scrollView?.mas_leading)
            _ = make?.width.mas_equalTo()(UISCREEN_WIDTH-100)
            _ = make?.height.top().equalTo()(weakSelf?.scrollView)
        })
        
        
        _ = mainView?.mas_makeConstraints({ (make) in
            
            _ = make?.leading.equalTo()(weakSelf?.scrollView?.mas_leading)?.offset()(UISCREEN_WIDTH-100)
            _ = make?.width.top().height().equalTo()(weakSelf!.view)
            
        })
        
        
        _ = tabBarChildVC!.view.mas_updateConstraints({ (make) in
            
            _ = make?.leading.equalTo()(weakSelf?.mainView?.mas_trailing)?.offset()(-(UISCREEN_WIDTH-100))
            _ = make?.width.top().height().equalTo()(weakSelf!.view)
            _ = make?.trailing.equalTo()(weakSelf?.scrollView?.mas_trailing)?.offset()(0)
            
        })
        
        self.view.setNeedsLayout()
        scrollView?.delegate = self;
        scrollView?.setContentOffset(CGPoint.init(x: 160, y: 0), animated: true)
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.bounces = false
        
        mainView?.headerView?.headIconClickBlock = { () in
            if weakSelf?.scrollView?.contentOffset.x == UISCREEN_WIDTH-100{
                weakSelf?.scrollView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }else{
                weakSelf?.scrollView?.setContentOffset(CGPoint.init(x: UISCREEN_WIDTH-100, y: 0), animated: true)
            }
        }
        
        configBaseData()
        //书架书籍选中事件
        mainView?.itemSelectedHandler = {(mod) in
            
            let model : BookModel = mod as! BookModel
            weakSelf?.showBookAnimationToRead(model: model)
            
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            self.animationImageView?.removeFromSuperview()
        
        }
        
    }
    func showBookAnimationToRead(model:BookModel) -> Void {
        
        if model.weakCell == nil {
            return
        }
        
        let frame = model.weakCell?.superview?.convert(model.weakCell!.frame, to: self.view)
        print(frame)
        
        
        animationImageView = UIImageView.init(image: model.weakCell?.image)
        animationImageView!.frame = frame!
        UIApplication.shared.keyWindow?.addSubview(animationImageView!)
        weak var weakSelf = self
        
        
         animationImageView?.layer.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        let 动画组 = CAAnimationGroup.init()
        let frame动画 = CABasicAnimation.init()
        frame动画.keyPath = "transform.scale.x"
        frame动画.fromValue = (0)
        frame动画.toValue = (UISCREEN_WIDTH / (frame?.size.width)!)
        print(UISCREEN_WIDTH / (frame?.size.width)!)
        frame动画.duration = 0.7
        
        
        let frame动画y = CABasicAnimation.init()
        frame动画y.keyPath = "transform.scale.y"
        frame动画y.fromValue = (0)
        frame动画y.toValue = (UISCREEN_HEIGHT / (frame?.size.height)!)
        print(UISCREEN_WIDTH / (frame?.size.width)!)
        frame动画y.duration = 0.7
        
        frame动画y.fillMode = kCAFillModeForwards
        
        let position动画 = CABasicAnimation.init()
        position动画.keyPath = "position"
        position动画.fromValue = NSValue.init(cgPoint: CGPoint.init(x: (animationImageView?.center.x)!, y: (animationImageView?.center.y)!))
        position动画.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: self.view.center.y))
        position动画.duration = 0.7
        position动画.fillMode = kCAFillModeForwards

        动画组.animations = [frame动画,frame动画y,position动画]
        动画组.duration = 0.7
        动画组.fillMode = kCAFillModeForwards
        动画组.isRemovedOnCompletion = false
        animationImageView?.layer.add(动画组, forKey: "group")
        
        
        animationImageView?.layer.transform.m34 = -2.5/2000
        let animation = CABasicAnimation.init()
        animation.keyPath = "transform.rotation.y"
        animation.duration = 0.5
        animation.fromValue = (0)
        animation.toValue = (-M_PI_2)
        animation.isRemovedOnCompletion = false
        animation.delegate = weakSelf
        animation.fillMode = kCAFillModeForwards
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7 ) {
            let vc = JHReadingViewController()
            vc.model = model
            weakSelf?.navigationController?.pushViewController(vc, animated: false)
            weakSelf?.animationImageView?.layer.add(animation, forKey: "animation")
        }
        

        
    }
    
    
    
    func configBaseData() -> Void {
        weak var weakSelf = self
        MainUtil().userInfoRequest(successHandler: { (response) in
            let user = response as! UserModel
            weakSelf?.leftMeumView?.headView?.titleLabel?.text = user.userName
            
            let url:String = (user.avastar?.url)!
            
            
            weakSelf?.leftMeumView?.headView?.headIconImageView?.sd_setImage(with: URL.init(string: url)!, placeholderImage: UIImage.init(named: "头像"))
            weakSelf?.leftMeumView?.headView?.subLabel?.text = "\(user.level!)"
            weakSelf?.mainView?.headerView?.iconImageView?.sd_setImage(with: URL.init(string: url)!, for: .normal, placeholderImage: UIImage.init(named: "头像"))
            
            
            },failHandler:{ (error) in
                
        })
        
        MainUtil().adInfoRequest(successHandler: { (obj) in
            let adArray = obj as! [ADModel]
            (weakSelf?.tabBarChildVC?.viewControllers?[0] as! JHRecommendVC).headerView?.adScrollView?.dataSourceArray = adArray
        },failHandler:  { (error) in
            
        })
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        weak var weakSelf = self
        if scrollView.contentOffset.x>UISCREEN_WIDTH - 100 {
            

            let res = (scrollView.contentOffset.x - UISCREEN_WIDTH + 100) / UISCREEN_WIDTH
            let offSet = 100-UISCREEN_WIDTH - (100-UISCREEN_WIDTH)*res
            
            _ = tabBarChildVC?.view.mas_updateConstraints({ (make) in
                _ = make?.leading.equalTo()(weakSelf?.mainView?.mas_trailing)?.offset()(offSet)
                    
            })


        }else{
            
            let res = -(scrollView.contentOffset.x - UISCREEN_WIDTH + 100) / UISCREEN_WIDTH
//            print(res)
            leftMeumView?.backgroundColor = UIColor.init(white: 0.7, alpha: 1-res)
            _ = self.leftMeumView?.mas_updateConstraints({ (make) in
                
                _ = make?.leading.equalTo()(weakSelf?.scrollView?.mas_leading)?.offset()(scrollView.contentOffset.x / 3)
                
            })
            
        }

    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.x<(UISCREEN_WIDTH-100)/2.0 {
            
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            
        }else if scrollView.contentOffset.x>=(UISCREEN_WIDTH-100)/2.0&&scrollView.contentOffset.x<=(UISCREEN_WIDTH-10){
            
            scrollView.setContentOffset(CGPoint.init(x: UISCREEN_WIDTH-100, y: 0), animated: true)
            
        }else if scrollView.contentOffset.x<UISCREEN_WIDTH-100 + (UISCREEN_WIDTH-100)/2.0{
            scrollView.setContentOffset(CGPoint.init(x: UISCREEN_WIDTH-100, y: 0), animated: true)
        }else{
            
            scrollView.setContentOffset(CGPoint.init(x: UISCREEN_WIDTH-100+UISCREEN_WIDTH, y: 0), animated: true)
        }
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
         self.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
    
    
    
    
    
    
    
}
