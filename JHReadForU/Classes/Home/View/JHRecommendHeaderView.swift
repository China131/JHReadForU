//
//  JHRecommendHeaderView.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/15.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit


class ADScrollView: UIScrollView,UIScrollViewDelegate {
    var timer:Timer?
    var index:Int?
    var scrollBlock:JHRequestBlock?
    var imageViewClickBlock:JHRequestBlock?
    let repeatTimerTravel:TimeInterval = 3.0
    var dataSourceArray:[ADModel]?{
        
        didSet{
            
            if dataSourceArray?.count == 0 {
                return
            }
            weak var weakSelf = self
            weak var superV = self.superview as? JHRecommendHeaderView
            superV?.pageControl?.numberOfPages = (dataSourceArray?.count)!
            
            for vs in self.subviews{
                vs.removeFromSuperview()
            }
            
            for i in  0..<dataSourceArray!.count+1{
                let adModel = dataSourceArray![i%dataSourceArray!.count]
                
                let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 200))
                imageView.sd_setImage(with: URL.init(string: (adModel.cover?.url)!)!, placeholderImage: UIImage.init(named: "placeholder"))
                imageView.contentMode = .scaleToFill
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                self.addSubview(imageView)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ADScrollView.imageViewClick(tap:)))
                imageView.addGestureRecognizer(tapGesture)
                _ = imageView.mas_makeConstraints({ (make) in
                    _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(UISCREEN_WIDTH * CGFloat.init(i))
                    _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(0)
                    _ = make?.height.equalTo()(weakSelf?.mas_height)
                    _ = make?.width.mas_equalTo()(weakSelf?.mas_width)
                    
                    if i == (weakSelf?.dataSourceArray!.count)! {
                        _ = make?.right.equalTo()(weakSelf?.mas_right)
                    }
                    
                })
            }
            
            
            timer?.invalidate()
            
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: repeatTimerTravel, repeats: true, block: { (timer) in
                    
                    weakSelf?.timerFire()
                })
            } else {
                // Fallback on earlier versions
                timer = Timer.scheduledTimer(timeInterval: repeatTimerTravel, target: self, selector: #selector(ADScrollView.timerFire), userInfo: nil, repeats: true)
            }
            
            timer?.fire()
            
        }
        
    }
    
    func imageViewClick(tap:UITapGestureRecognizer) -> Void {
        let imageView = tap.view
        if let block = imageViewClickBlock {
            block(dataSourceArray?[imageView!.tag % ((dataSourceArray?.count)!+1)])
        }
    }
    
    
    func timerFire() -> Void {
        
        index! += 1
//        print(index)
        self.setContentOffset(CGPoint.init(x: CGFloat(index! % (dataSourceArray!.count+1)) * UISCREEN_WIDTH, y: 0), animated: true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       timer?.invalidate()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let count = scrollView.contentOffset.x / UISCREEN_WIDTH
        if Int(count) == (dataSourceArray?.count)! {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            if let v = scrollBlock {
                index = 0
                v(CGFloat(0))
                
            }
        }else{
            if let v = scrollBlock {
                index = Int(count)
                v(count)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        weak var weakSelf = self
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: repeatTimerTravel, repeats: true, block: { (timer) in
                
                weakSelf?.timerFire()
            })
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: repeatTimerTravel, target: self, selector: #selector(ADScrollView.timerFire), userInfo: nil, repeats: true)
        }
        timer?.fire()
//        print("stop dragging")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
       scrollViewDidEndDecelerating(scrollView)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        index = -1
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

class JHListButton: UIButton {
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: (contentRect.size.width - 20) / 2 , y: 10, width: 20, height: 20)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0 , y: (contentRect.size.height - 30) / 2 + 18, width: contentRect.size.width, height: 30)
    }
    
    
}



class JHListViewHorizen: UIView {
    var imageArray:[String]?
    var nameArray:[String]?
    
    func toudown(button:JHListButton) -> Void {
        
        button.backgroundColor = JHBaseBackGroundColor
    }
    
    func touchUp(button:JHListButton) -> Void {
         button.backgroundColor = UIColor.white
    }
    
    func touchupInSide(button:JHListButton) -> Void {
        button.backgroundColor = UIColor.white
        
        
    }
    
    func showView() -> Void {
        self.backgroundColor = UIColor.white
        let wid = UISCREEN_WIDTH / CGFloat((imageArray?.count)!)
        weak var weakSelf = self
        for i in 0..<(imageArray?.count)!{
            
            let button:JHListButton = JHListButton.init(type: .custom)
            button.setImage(UIImage.init(named: imageArray![i]), for: .normal)
            button.setTitle(nameArray![i], for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(JHListViewHorizen.toudown(button:)), for: .touchDown)
            button.addTarget(self, action: #selector(JHListViewHorizen.touchUp(button:)), for: .touchDragExit)
            button.addTarget(self, action: #selector(JHListViewHorizen.touchUp(button:)), for: .touchDragOutside)
            button.addTarget(self, action: #selector(JHListViewHorizen.touchUp(button:)), for: .touchCancel)
            button.addTarget(self, action: #selector(JHListViewHorizen.touchupInSide(button:)), for: .touchUpInside)
            self.addSubview(button)
            
            button.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(wid * CGFloat(i))
                _ = make?.width.mas_equalTo()(wid)
                _ = make?.height.mas_equalTo()(50)
                _ = make?.top.equalTo()(weakSelf?.mas_top)
            })
            
        }
        
        
    }
    
}


class ChannelView: UIView {
    
    var titleLabel:UILabel?
    var subTitleLabel:UILabel?
    var settingImageView:UIImageView?
    init(channelTitle:String,category:[String]) {
        
        super.init(frame: CGRect.init())
        self.backgroundColor = UIColor.white
        titleLabel = UILabel.init()
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textColor = UIColor.orange
        titleLabel?.textAlignment = .center
        titleLabel?.text = channelTitle
        self.addSubview(titleLabel!)
        
        subTitleLabel = UILabel.init()
        subTitleLabel?.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel?.textColor = UIColor.lightGray
        subTitleLabel?.textAlignment = .center
        self.addSubview(subTitleLabel!)
        
        settingImageView = UIImageView.init()
        settingImageView?.image = UIImage.init(named: "设置")
        self.addSubview(settingImageView!)
        weak var weakSelf = self
        
        _ = titleLabel?.mas_makeConstraints({ (make) in
            _ = make?.centerX.equalTo()(weakSelf?.mas_centerX)
            _ = make?.bottom.equalTo()(weakSelf?.mas_centerY)
        })
        
        _ = subTitleLabel?.mas_makeConstraints({ (make) in
            _ = make?.centerX.equalTo()(weakSelf?.titleLabel?.mas_centerX)
            _ = make?.top.equalTo()(weakSelf?.titleLabel?.mas_bottom)
        })
        
        _ = settingImageView?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-15)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
            _ = make?.width.height().mas_equalTo()(20)
        })
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class JHRecommendHeaderView: UIView {
    var adScrollView:ADScrollView?
    var pageControl:UIPageControl?
    var imageClickBlock:JHRequestBlock?
    var horizonView:JHListViewHorizen?
    var channelView:ChannelView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        adScrollView = ADScrollView.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 200))
        self.addSubview(adScrollView!)
        weak var weakSelf = self
        
        
        _ = adScrollView?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.mas_left)
            _ = make?.right.equalTo()(weakSelf?.mas_right)
            _ = make?.top.equalTo()(weakSelf?.mas_top)
            _ = make?.height.mas_equalTo()(160)
        })
        
        
        pageControl = UIPageControl.init(frame: CGRect.init())
        pageControl?.numberOfPages = 4
        pageControl?.currentPageIndicatorTintColor = JHBaseLightGrayColor
        pageControl?.pageIndicatorTintColor = UIColor.white
        self.addSubview(pageControl!)
        
        
        _ = pageControl?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-10)
            _ = make?.bottom.equalTo()(weakSelf?.adScrollView?.mas_bottom)?.offset()(0)
            _ = make?.width.mas_equalTo()(80)
        })

        
        adScrollView!.scrollBlock = {(index)->Void in
            let i:Int = Int.init(index as! CGFloat)
            weakSelf?.pageControl?.currentPage = i
        }
        
        
        adScrollView?.imageViewClickBlock = { model -> Void in
            if let block = weakSelf?.imageClickBlock {
                block(model)
            }
        }
        
        
        let nameList = ["男频","女频","出版","漫画","免费","更多"]
        let imageList = ["男","女","书本-1","动画动漫","免费","更多"]
        horizonView = JHListViewHorizen.init(frame: CGRect.init())
        self.addSubview(horizonView!)
        horizonView?.imageArray = imageList
        horizonView?.nameArray = nameList
        
        _ = horizonView?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.adScrollView?.mas_bottom)
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.height.mas_equalTo()(60)
        })
        
        horizonView?.showView()
        
        channelView = ChannelView.init(channelTitle: "男生小说频道", category: ["ewiroewi"])
        self.addSubview(channelView!)
        
        _ = channelView?.mas_makeConstraints({ (make) in
            
            _ = make?.top.equalTo()(weakSelf?.horizonView?.mas_bottom)?.offset()(10)
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.height.equalTo()(70)
            
        })
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


class SectionHeaderView: UIView {
    
    var titleLabel:UILabel?
    var buttonTitle:UIButton?
    var buttonImageName:String?
    var button:UIButton?
    init(title:String,buttonTitle:String,buttonImageName:String){
    
        super.init(frame:CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 20))
        self.backgroundColor = UIColor.white
        let headLine = UIView.init(frame: CGRect.init())
        headLine.backgroundColor = JHBaseLightGrayColor
        self.addSubview(headLine)
        
        titleLabel = UILabel.init()
        titleLabel?.textColor = UIColor.darkGray
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.text = title
        self.addSubview(titleLabel!)
        
        
        button = UIButton.init(type: .custom)
        button?.setTitle(buttonTitle, for: .normal)
        button?.setImage(UIImage.init(named: buttonImageName), for: .normal)
        button?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button?.setTitleColor(UIColor.lightGray, for: .normal)
        self.addSubview(button!)
        weak var weakSelf = self
        headLine.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(10)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
            _ = make?.width.mas_equalTo()(3)
            _ = make?.height.mas_equalTo()(15)
        }
        
        
        _ = titleLabel?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(headLine.mas_left)?.offset()(15)
            _ = make?.centerY.equalTo()(headLine.mas_centerY)
        })
        
        _ = button?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-15)
            _ = make?.centerY.equalTo()(headLine.mas_centerY)
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




class JHScrollViewCell: UITableViewCell {
    var scrollView:JHFlowView?
    var dataSources:[BookCategoryModel]?{
        didSet{
            
            scrollView?.dataSourceArray = dataSources
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: "ScrollViewCell")
        if scrollView == nil {
            weak var weakSelf = self
            scrollView = JHFlowView.init(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
            self.contentView.addSubview(scrollView!)
            _ = scrollView?.mas_makeConstraints({ (make) in
                _ = make?.top.left().bottom().right().equalTo()(weakSelf?.contentView)
            })
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}








