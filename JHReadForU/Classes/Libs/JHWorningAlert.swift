//
//  JHWorningAlert.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/18.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHWorningAlert: UIView {
    var imageView:UIImageView?
    var infoLabel:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init()
        self.addSubview(imageView!)
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true
        
        infoLabel = UILabel.init()
        infoLabel?.font = UIFont.systemFont(ofSize: 12)
        infoLabel?.textColor = UIColor.white
        infoLabel?.textAlignment = .center
        self.addSubview(infoLabel!)
        
        weak var weakSelf = self
        _ = imageView?.mas_makeConstraints({ (make) in
           _ = make?.centerX.equalTo()(weakSelf?.mas_centerX)
           _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)?.offset()(-10)
           _ = make?.width.height().mas_equalTo()(40)
        })
        
        _ = infoLabel?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.imageView?.mas_bottom)?.offset()(10)
            _ = make?.left.right().equalTo()(weakSelf)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func showWorningWithString(string:String) -> Void {
        let vi = JHWorningAlert.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        vi.center = CGPoint.init(x: UISCREEN_WIDTH / 2, y: UISCREEN_HEIGHT / 2)
        vi.imageView?.image = UIImage.init(named: "闪电")
        vi.infoLabel?.text = string
        UIApplication.shared.keyWindow?.addSubview(vi)
        UIView.animate(withDuration: 1.0, delay: 1.5, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseIn, animations: { 
            
            vi.alpha = 0
            
            }) { (finish) in
                if finish{
                    vi.removeFromSuperview()
                }
        }
        
    }
    
    public func showSuccessWithString(string:String) -> Void {
        let vi = JHWorningAlert.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        vi.center = CGPoint.init(x: UISCREEN_WIDTH / 2, y: UISCREEN_HEIGHT / 2)
        vi.imageView?.image = UIImage.init(named: "笑脸")
        vi.infoLabel?.text = string
        UIApplication.shared.keyWindow?.addSubview(vi)
        UIView.animate(withDuration: 1.0, delay: 1.5, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            vi.alpha = 0
            
        }) { (finish) in
            if finish{
                vi.removeFromSuperview()
            }
        }
        
    }

}
