//
//  MainLeftMeumView.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/14.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import Masonry


class MeumHeader: UIView {
    
    var headIconImageView:UIImageView?
    var titleLabel:UILabel?
    var subLabel:UILabel?
    override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = JHBaseLightGrayColor
        headIconImageView = UIImageView.init()
        headIconImageView?.image = UIImage.init(named: "headIcon.jpg")
        headIconImageView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MeumHeader.iconImageTap))
        headIconImageView?.addGestureRecognizer(tap)
        self.addSubview(headIconImageView!)
        headIconImageView?.layer.cornerRadius = 25
        headIconImageView?.layer.masksToBounds = true
        
        
        titleLabel = UILabel.init()
        titleLabel?.textColor = UIColor.darkGray
        self.addSubview(titleLabel!)
        
        subLabel = UILabel.init()
        self.addSubview(subLabel!)
        
        
        let anchor:UIImageView = UIImageView.init()
        anchor.image = UIImage.init(named: "右")
        self.addSubview(anchor)
        
        weak var weakSelf = self
        _ = headIconImageView?.mas_makeConstraints({ (make) in
            _ = make?.top.mas_equalTo()(40)
            _ = make?.left.mas_equalTo()(15)
            _ = make?.width.height().mas_equalTo()(50)
            
        })
        
        _ = titleLabel?.mas_makeConstraints({ (make) in
            _ = make?.bottom.equalTo()(weakSelf?.headIconImageView?.mas_centerY)?.offset()(-3)
            _ = make?.left.equalTo()(weakSelf?.headIconImageView?.mas_right)?.offset()(20)
        })
        
        _ = subLabel?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.titleLabel?.mas_left)
            _ = make?.top.equalTo()(weakSelf?.headIconImageView?.mas_centerY)?.offset()(3)
        })
        
        titleLabel?.text = "i841313257"
        subLabel?.text = "未进入阅读排名"
        
        anchor.mas_makeConstraints { (make) in
            _ = make?.trailing.equalTo()(weakSelf?.mas_trailing)?.offset()(-5)
            _ = make?.width.height().equalTo()(20)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
        }
        
    }
    
    func iconImageTap() -> Void {
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}



class JHMainLeftCell: UITableViewCell {
    var iconImageView:UIImageView?
    var titleLabel:UILabel?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        iconImageView = UIImageView.init()
        self.addSubview(iconImageView!)
        
        titleLabel = UILabel.init()
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textColor = UIColor.darkText
        self.addSubview(titleLabel!)
        
        weak var weakSelf = self
        
        _ = iconImageView?.mas_makeConstraints({ (make) in
            _ = make?.left.mas_equalTo()(25)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
            _ = make?.width.height().mas_equalTo()(30)
        })
        
        _ = titleLabel?.mas_makeConstraints({ (make) in
           _ =  make?.left.equalTo()(weakSelf?.iconImageView?.mas_right)?.offset()(10)
           _ =  make?.centerY.equalTo()(weakSelf?.mas_centerY)
        })
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}




class MainLeftMeumView: UIView,UITableViewDataSource,UITableViewDelegate {

   
    open var headView:MeumHeader?
    var tableView:UITableView?
    let titleArray = ["我的消息","我的资产","我的VIP","你要的阅读神器","掌阅纸书","活动中心","签到/任务","今日免费"]
    override init(frame: CGRect) {
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH-100, height: 0))
        self.backgroundColor = JHBaseBackGroundColor
        tableView = UITableView.init(frame: CGRect.init(), style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(JHMainLeftCell.classForCoder(), forCellReuseIdentifier: "mainLeft")
        self.addSubview(tableView!)
        weak var weakSelf = self
        _ = tableView?.mas_makeConstraints({ (make) in
            
            _ = make?.top.left().bottom().right().equalTo()(weakSelf)
            
        })
        
        headView = MeumHeader.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH - 100, height: 120))
        tableView?.tableHeaderView = headView
        tableView?.tableFooterView = UIView.init()
        tableView?.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:JHMainLeftCell = tableView.dequeueReusableCell(withIdentifier: "mainLeft")! as! JHMainLeftCell
        cell.titleLabel?.text = titleArray[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }

}
















