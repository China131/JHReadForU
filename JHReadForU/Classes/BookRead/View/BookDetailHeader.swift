//
//  BookDetailHeader.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/17.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import Foundation

class LeftImageRightTitleButton: UIButton {
    let imageWidth = CGFloat(20)
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect.init(x: contentRect.origin.x + (contentRect.size.width - imageWidth) / 2 - 18, y: (contentRect.size.height - imageWidth) / 2, width: imageWidth, height: imageWidth)
        
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: contentRect.origin.x + (contentRect.size.width - imageWidth) / 2 + imageWidth-13 , y: (contentRect.size.height - 30) / 2, width: contentRect.size.width - ( contentRect.origin.x + (contentRect.size.width - imageWidth) / 2 + imageWidth-13), height: 30)
    }
}



//书籍相关操作视图 打赏 点赞 分享等
class BookOperationView: UIView {
    
    let titleArray = ["打赏","赞","分享","投票"]
    let 正常图片 = ["打赏normal","赞赞normal","分享","投票normal"]
    let 高亮图片 = ["打赏height","赞赞","分享","投票height"]
    
    init(model:BookModel) {
        
        super.init(frame: CGRect.init())
        let wid = UISCREEN_WIDTH / CGFloat(titleArray.count)
        weak var weakSelf = self
        for i in 0..<titleArray.count{
            let btn = LeftImageRightTitleButton.init(type: .custom)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.textAlignment = .left
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setImage(UIImage.init(named: 正常图片[i]), for: .normal)
            
           
            
            self.addSubview(btn)
            
            _ = btn.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(CGFloat(i) * wid)
                _ = make?.top.bottom().equalTo()(weakSelf)
                _ = make?.width.mas_equalTo()(wid)
                
            })
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
//书籍评分展示控件
class BookStarView: UIView {
    
    init(isHeight:Bool) {
        super.init(frame:CGRect.init())
        weak var weakSelf = self
        let w_H = 15
        for i in 0...4{
            let imageV = UIImageView.init()
            if isHeight{
                imageV.image = UIImage.init(named: "星星height")
            }else{
                imageV.image = UIImage.init(named: "星星normal")
            }
            self.addSubview(imageV)
            
            _ = imageV.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(CGFloat(i*w_H))
                _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
                _ = make?.width.height().mas_equalTo()(w_H)
            })

        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//书籍详情界面的头部 包括书籍基本信息
class BookDetailHeader: UIView {

    var bookCoverImageView:UIImageView?
    var bookStartView:BookStarView?
    var bookStratNormal:BookStarView?
    var bookNameLabel:UILabel?
    var bookMakerLabel:UILabel?
    var cateGoryNameLabel:UILabel?
    var bookStateLabel:UILabel?
    var bookDownLoadCountLabel:UILabel?
    var favoriteLabel:UILabel?
    var voteLabel:UILabel?
    let fontSize = CGFloat(13.0)
    let color = UIColor.darkGray
    var model:BookModel?
    let w_H = 15
    init(models:BookModel) {
        super.init(frame: CGRect.init())
        model = models
        bookCoverImageView = UIImageView.init()
        bookCoverImageView?.image = UIImage.init(named: "书籍默认封面")
        if models.book_CoverIcon?.url != nil{
            bookCoverImageView?.sd_setImage(with: URL.init(string: (models.book_CoverIcon?.url!)!)!, placeholderImage: UIImage.init(named: "书籍默认封面"))
        }
        
        self.addSubview(bookCoverImageView!)
        
        bookNameLabel = UILabel.init()
        bookNameLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bookNameLabel?.textColor = UIColor.black
        bookNameLabel?.textAlignment = .left
        bookNameLabel?.text = models.book_name
        self.addSubview(bookNameLabel!)
        
        bookStratNormal = BookStarView.init(isHeight: false)
        self.addSubview(bookStratNormal!)
        bookStartView = BookStarView.init(isHeight: true)
        bookStartView?.clipsToBounds = true
        self.addSubview(bookStartView!)
        

        
        bookMakerLabel = UILabel.init()
        bookMakerLabel?.textColor = color
        bookMakerLabel?.font = UIFont.systemFont(ofSize: fontSize)
        bookMakerLabel?.text = "作者: " + "\(models.book_Maker!)"
        self.addSubview(bookMakerLabel!)
        
        cateGoryNameLabel = UILabel.init()
        cateGoryNameLabel?.textColor = color
        cateGoryNameLabel?.font = UIFont.systemFont(ofSize: fontSize)
        cateGoryNameLabel?.text = "类别: " + "\(models.category!)"
        self.addSubview(cateGoryNameLabel!)
        
        bookStateLabel = UILabel.init()
        bookStateLabel?.textColor = color
        bookStateLabel?.font = UIFont.systemFont(ofSize: fontSize)
        bookStateLabel?.text =  "状态: "
        if let value = models.book_State{
            bookStateLabel?.text =  "状态: " + "\(value)"
        }
        
        self.addSubview(bookStateLabel!)
        
        bookDownLoadCountLabel = UILabel.init()
        bookDownLoadCountLabel?.textColor = color
        bookDownLoadCountLabel?.font = UIFont.systemFont(ofSize: fontSize)
        bookDownLoadCountLabel?.text = "下载量: " + "\(models.DownloadCount!)"
        self.addSubview(bookDownLoadCountLabel!)
        
        favoriteLabel = UILabel.init()
        favoriteLabel?.textColor = color
        favoriteLabel?.font = UIFont.systemFont(ofSize: fontSize)
        if let text = models.favorite{
             favoriteLabel?.text = "点赞量: " + "\(text)"
        }
       
        self.addSubview(favoriteLabel!)
        
        voteLabel = UILabel.init()
        voteLabel?.textColor = color
        voteLabel?.font = UIFont.systemFont(ofSize: fontSize)
        voteLabel?.text = "投票量: " + "\(models.vote!)"
        self.addSubview(voteLabel!)
        
        updateSubViewsLayout()
        
    }
    
    func updateSubViewsLayout() -> Void {
        weak var weakSelf = self
        _ = bookCoverImageView?.mas_makeConstraints({ (make) in
            _ = make?.top.left().equalTo()(weakSelf)?.offset()(15)
            _ = make?.width.mas_equalTo()(185/2)
            _ = make?.height.mas_equalTo()(260/2)
        })
        
        _ = bookNameLabel?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.bookCoverImageView?.mas_top)
            _ = make?.left.equalTo()(weakSelf?.bookCoverImageView?.mas_right)?.offset()(15)
        })
        
        _ = bookStratNormal?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.bookNameLabel?.mas_bottom)?.offset()(5)
            _ = make?.left.equalTo()(weakSelf?.bookNameLabel?.mas_left)
            _ = make?.width.mas_equalTo()((weakSelf?.w_H)!*5)
            _ = make?.height.mas_equalTo()(20)
        })
        
        
        let value = (weakSelf?.model?.rate?.floatValue)! / 100.0
        
        _ = bookStartView?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.bookNameLabel?.mas_bottom)?.offset()(5)
            _ = make?.left.equalTo()(weakSelf?.bookNameLabel?.mas_left)
            _ = make?.width.mas_equalTo()(value * Float((weakSelf?.w_H)! * 5))
            _ = make?.height.mas_equalTo()(20)
        })
        
        _ = cateGoryNameLabel?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.bookStartView?.mas_bottom)?.offset()(5)
            _ = make?.left.equalTo()(weakSelf?.bookNameLabel?.mas_left)
        })
        
        _ = bookMakerLabel?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.cateGoryNameLabel?.mas_bottom)?.offset()(5)
            _ = make?.left.equalTo()(weakSelf?.bookNameLabel?.mas_left)
        })
        
        
        _ = bookDownLoadCountLabel?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.bookMakerLabel?.mas_bottom)?.offset()(5)
            _ = make?.left.equalTo()(weakSelf?.bookNameLabel?.mas_left)
        })
        
        
        _ = bookStateLabel?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.mas_right)?.offset()(-120)
            _ = make?.top.equalTo()(weakSelf?.bookStartView?.mas_bottom)?.offset()(5)
        })
        
        _ = favoriteLabel?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.bookStateLabel?.mas_left)
            _ = make?.top.equalTo()(weakSelf?.bookStateLabel?.mas_bottom)?.offset()(5)
        })
        
        _ = voteLabel?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.favoriteLabel?.mas_left)
            _ = make?.top.equalTo()(weakSelf?.favoriteLabel?.mas_bottom)?.offset()(5)
        })
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//书籍简介控件
class IntroductionView: UIView {
    
    var label:UILabel?
    
    init(words:String) {
        super.init(frame: CGRect.init())
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.text = "内容简介"
        self.addSubview(titleLabel)
        
        label = UILabel.init()
        label?.textColor = UIColor.darkGray
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.numberOfLines = 0
        label?.text = words
        self.addSubview(label!)
        weak var weakSelf = self
        _ = titleLabel.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(10)
            _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(10)
            _ = make?.height.mas_equalTo()(20)
        })
        
        _ = label?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(titleLabel.mas_left)
            _ = make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(3)
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-5)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()(-5)
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//书籍详情界面的头部视图
class TableViewHeader: UIView {
    var topView:BookDetailHeader?
    var operatView:BookOperationView?
    var introductionView:IntroductionView?
    init(model:BookModel) {
        super.init(frame: CGRect.init())
        topView = BookDetailHeader.init(models: model)
        topView?.backgroundColor = UIColor.white
        self.addSubview(topView!)
        
        operatView = BookOperationView.init(model: model)
        operatView?.backgroundColor = UIColor.white
        self.addSubview(operatView!)
        
        
        introductionView = IntroductionView.init(words: model.introduction!)
        introductionView?.backgroundColor = UIColor.white
        self.addSubview(introductionView!)
        
        weak var weakSelf = self
        _ = topView?.mas_makeConstraints({ (make) in
            _ = make?.left.top().right().equalTo()(weakSelf)
            _ = make?.height.mas_equalTo()(150)
        })
        
        _ = operatView?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.topView?.mas_bottom)?.offset()(1)
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.height.mas_equalTo()(45)
        })
        
        _ = introductionView?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.operatView?.mas_bottom)?.offset()(1)
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()(-10)
        })
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class TopAndRightTitleButton: UIButton {
    let wid = CGFloat(20)
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x:wid , y: -3, width: 60, height: 20)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0, y:  (contentRect.size.height - wid) / 2 + contentRect.origin.y, width: wid, height: wid)
    }
    
}


class CommentButton: UIButton {
    let wid = CGFloat(15)
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 5, y: (contentRect.size.height - wid) / 2 + contentRect.origin.y, width: wid, height: wid)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 5+5+wid, y: (contentRect.size.height - wid) / 2 + contentRect.origin.y, width: contentRect.size.width - 10 - wid, height: wid)
    }
    
}


//评论栏
class WriteCommentView: UIView {
    
    var writeButton:CommentButton?
    var commentButton:TopAndRightTitleButton?
    var favoriteButton:TopAndRightTitleButton?
    var shareButton:UIButton?
    let fontSize = CGFloat(12)
    let color = UIColor.lightGray
    var editCommentClickHandler:JHBlockWithNoneParamter?
    var favoriteButtonHandler:JHBlockWithNoneParamter?
    var shareClickHandler:JHBlockWithNoneParamter?
    func editBtnClick(button:CommentButton) -> Void {
        
        if let v = editCommentClickHandler {
            v()
        }
        
    }
    func favoriteButtonClick() -> Void {
        
        favoriteButtonHandler == nil ? () : favoriteButtonHandler!()
        
    }
    
    func shareButtonClick() -> Void {
        
        shareClickHandler == nil ? () : shareClickHandler!()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        writeButton = CommentButton.init(type:.custom)
        writeButton?.setImage(UIImage.init(named: "写"), for: .normal)
        writeButton?.setTitle("写下你的评论...", for: .normal)
        writeButton?.layer.cornerRadius = 5.0
        writeButton?.layer.masksToBounds = true
        writeButton?.layer.borderWidth = 1.0
        writeButton?.layer.borderColor = UIColor.lightGray.cgColor
        writeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        writeButton?.setTitleColor(color, for: .normal)
        writeButton?.addTarget(self, action: #selector(WriteCommentView.editBtnClick(button:)), for: .touchUpInside)
        self.addSubview(writeButton!)
        

        favoriteButton = TopAndRightTitleButton.init(type:.custom)
        favoriteButton?.setImage(UIImage.init(named: "赞赞normal"), for: .normal)
        favoriteButton?.setTitle("0", for: .normal)
        favoriteButton?.titleLabel?.textAlignment = .left
        favoriteButton?.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        favoriteButton?.setTitleColor(color, for: .normal)
        favoriteButton?.addTarget(self, action: #selector(WriteCommentView.favoriteButtonClick), for: .touchUpInside)
        self.addSubview(favoriteButton!)
        
        shareButton = TopAndRightTitleButton.init(type: .custom)
        shareButton?.setImage(UIImage.init(named: "分享"), for: .normal)
        shareButton?.addTarget(self, action: #selector(WriteCommentView.shareButtonClick), for: .touchUpInside)
        self.addSubview(shareButton!)
        
        weak var weakSelf = self
       

        _ = shareButton?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-10)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
            _ = make?.width.height().mas_equalTo()(30)
        })
        
        _ = favoriteButton?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.shareButton?.mas_left)?.offset()(-15)
            _ = make?.centerY.equalTo()(weakSelf?.mas_centerY)
            _ = make?.width.height().mas_equalTo()(40)
        })
        
        _ = writeButton?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()(10)
            _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(5)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()(-5)
            _ = make?.right.equalTo()(weakSelf?.favoriteButton?.mas_left)?.offset()(-15)
        })
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class EditStarView: UIView {
    let spa = CGFloat(15)
    let wid = CGFloat(25)
    var leading:CGFloat?
    var starArray:[UIImageView]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        starArray = Array.init()
        leading =  CGFloat(UISCREEN_WIDTH - wid * 5 - spa * 4) / 2
        weak var weakSelf = self
        for i in 0...4{
            
            let imageView = UIImageView.init()
            imageView.image = UIImage.init(named: "星星normal")
            self.addSubview(imageView)
            
            imageView.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()((weakSelf?.leading)! + CGFloat(i) * ((weakSelf?.wid)! + (weakSelf?.spa)!))
                _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(15)
                _ = make?.width.height().mas_equalTo()(self.wid)
            })
            
        }
        
        for i in 0...2{
            
            let imageView = UIImageView.init()
            imageView.image = UIImage.init(named: "星星height")
            starArray?.append(imageView)
            self.addSubview(imageView)
            
            imageView.mas_makeConstraints({ (make) in
                _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()((weakSelf?.leading)! + CGFloat(i) * ((weakSelf?.wid)! + (weakSelf?.spa)!))
                _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(15)
                _ = make?.width.height().mas_equalTo()(self.wid)
            })
            
            
        }

        
        let infoLabel = UILabel.init()
        infoLabel.text = "轻触✨评分"
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = UIColor.darkGray
        infoLabel.textAlignment = .center
        self.addSubview(infoLabel)
        
        infoLabel.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()(-5)
            _ = make?.centerX.equalTo()(weakSelf?.mas_centerX)
        }
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self)
        if (p?.x)!>self.leading! && (p?.y)! > CGFloat(15) && (p?.y)! < wid + 15 {
            
             var index:Int = Int(((p?.x)!-leading!) / (wid + spa))
            if index>4 {
                index = 4
            }
            weak var weakSelf = self
            
            for imageV in starArray!{
                
                imageV.removeFromSuperview()
            }
            starArray?.removeAll()
            
            for i in 0...index{
                
                let imageView = UIImageView.init()
                imageView.image = UIImage.init(named: "星星height")
                starArray?.append(imageView)
                self.addSubview(imageView)
                
                imageView.mas_makeConstraints({ (make) in
                    _ = make?.left.equalTo()(weakSelf?.mas_left)?.offset()((weakSelf?.leading)! + CGFloat(i) * ((weakSelf?.wid)! + (weakSelf?.spa)!))
                    _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(15)
                    _ = make?.width.height().mas_equalTo()(self.wid)
                })

                
            }
            
            
        }
       
        
        
    }
    
    
}




//评论编辑界面
class EditCommentContentView: UIView {
    var editStarView:EditStarView?
    var editTextView:UITextView?
    var commitButton:UIButton?
    var bgView:UIView?
    var height:CGFloat = CGFloat(0)
    var commitClickHandler:JHStringAndIntBlock?

    func selfClick() -> Void {
        self.editTextView?.resignFirstResponder()
        weak var weakSelf = self
        height = CGFloat(0)
        UIView.animate(withDuration: 1.0) {
            _ = weakSelf?.bgView?.mas_updateConstraints({ (make) in
                _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            })
           weakSelf?.layoutIfNeeded()
        }
        self.removeFromSuperview()
    }
    
    func commitButtonClick() -> Void {
        let string = NSString.init(string: (editTextView?.text)!)
        if string.length == 0{
            JHWorningAlert().showWorningWithString(string: "未填写评论内容")
            return
        }
        
        commitClickHandler != nil ? commitClickHandler!((editTextView?.text)!,(editStarView?.starArray?.count)!):()
        
        hideSelf()
    }
    
   
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
   
        
        self.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0)
        
        
        bgView = UIView.init(frame: CGRect.init(x: 0, y: UISCREEN_HEIGHT, width: UISCREEN_WIDTH, height: 135))
        bgView?.backgroundColor = JHBaseBackGroundColor
        self.addSubview(bgView!)
        weak var weakSelf = self
        _ = bgView?.mas_makeConstraints({ (make) in
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            _ = make?.height.mas_equalTo()(195)
        })
        
        
        editStarView = EditStarView.init(frame: CGRect.init())
        bgView?.addSubview(editStarView!)
        
        editStarView?.mas_makeConstraints({ (make) in
            _ = make?.right.left().equalTo()(weakSelf?.bgView)
            _ = make?.top.equalTo()(weakSelf?.bgView?.mas_top)
            _ = make?.height.mas_equalTo()(70)
        })
        
        
        
        editTextView = UITextView.init(frame: CGRect.init())
        editTextView?.backgroundColor = UIColor.white
        editTextView?.layer.cornerRadius = 4.0
        editTextView?.layer.masksToBounds = true
        editTextView?.layer.borderColor = UIColor.lightGray.cgColor
        editTextView?.layer.borderWidth = 1.0
        self.bgView!.addSubview(editTextView!)
        
        commitButton = UIButton.init(type: .custom)
        commitButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commitButton?.setTitle("发表评论", for: .normal)
        commitButton?.backgroundColor = JHBaseLightGrayColor
        commitButton?.layer.cornerRadius = 4.0
        commitButton?.layer.masksToBounds = true
        commitButton?.addTarget(self, action: #selector(EditCommentContentView.commitButtonClick), for: .touchUpInside)
        self.bgView!.addSubview(commitButton!)
        
        
        _ = editTextView?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.bgView?.mas_left)?.offset()(15)
            _ = make?.right.equalTo()(weakSelf?.bgView?.mas_right)?.offset()(-15)
            _ = make?.top.equalTo()(weakSelf?.editStarView?.mas_bottom)?.offset()(5)
            _ = make?.height.mas_equalTo()(80)
        })
        
        
        _ = commitButton?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.editTextView?.mas_bottom)?.offset()(5)
            _ = make?.left.right().equalTo()(weakSelf?.editTextView)
            _ = make?.height.mas_equalTo()(30)
        })
        
        self.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(EditCommentContentView.keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    public func showAnimation() ->Void{
        editTextView?.becomeFirstResponder()
    }
    
    
    func keyBoardWillShow(notification:Notification) -> Void {
        
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        height = -value.cgRectValue.size.height
        
        let value2 = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let during = value2.doubleValue
        weak var weakSelf = self
       
        
        
//        self.bgView?.setNeedsUpdateConstraints()
//        self.bgView?.updateConstraintsIfNeeded()
//        
        _ = self.bgView?.mas_updateConstraints({ (make) in
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
        })
        UIView.animate(withDuration: 0.2) {
           weakSelf?.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0.5)
           weakSelf?.layoutIfNeeded()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func hideSelf() -> Void {
        self.editTextView?.resignFirstResponder()
        weak var weakSelf = self
        height = CGFloat(195)
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0)
            weakSelf?.bgView?.mas_updateConstraints({ (make) in
                make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            })
            weakSelf?.layoutIfNeeded()
            
            }, completion: { (finish) in
                if finish{
                    weakSelf?.editTextView?.text = ""
                    weakSelf?.removeFromSuperview()
                }
        })

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let p = touches.first?.location(in: self)
        if (p?.y)!<(self.bgView?.frame.origin.y)!{
           
            
            hideSelf()
            
        }
        
    }
    
    
}



//二级评论编辑界面
class SubEditCommentContentView: UIView {

    var editTextView:UITextView?
    var commitButton:UIButton?
    var bgView:UIView?
    var height:CGFloat = CGFloat(0)
    var model:BookCommentModel?
    var commitClickHandler:JHStringAndIntBlock?{
        didSet{
            
            
        }
    }
    func selfClick() -> Void {
        self.editTextView?.resignFirstResponder()
        weak var weakSelf = self
        height = CGFloat(0)
        UIView.animate(withDuration: 1.0) {
            _ = weakSelf?.bgView?.mas_updateConstraints({ (make) in
                _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            })
            weakSelf?.layoutIfNeeded()
        }
        self.removeFromSuperview()
    }
    
    func commitButtonClick() -> Void {
        let string = NSString.init(string: (editTextView?.text)!)
        if string.length == 0{
            JHWorningAlert().showWorningWithString(string: "未填写评论内容")
            return
        }
        

        commitClickHandler != nil ? commitClickHandler!((editTextView?.text)!,0):()
        hideSelf()
    }
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        self.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0)
        
        
        bgView = UIView.init(frame: CGRect.init(x: 0, y: UISCREEN_HEIGHT, width: UISCREEN_WIDTH, height: 135))
        bgView?.backgroundColor = JHBaseBackGroundColor
        self.addSubview(bgView!)
        weak var weakSelf = self
        _ = bgView?.mas_makeConstraints({ (make) in
            _ = make?.left.right().equalTo()(weakSelf)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            _ = make?.height.mas_equalTo()(135)
        })
        

        
        editTextView = UITextView.init(frame: CGRect.init())
        editTextView?.backgroundColor = UIColor.white
        editTextView?.layer.cornerRadius = 4.0
        editTextView?.layer.masksToBounds = true
        editTextView?.layer.borderColor = UIColor.lightGray.cgColor
        editTextView?.layer.borderWidth = 1.0
        self.bgView!.addSubview(editTextView!)
        
        commitButton = UIButton.init(type: .custom)
        commitButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commitButton?.setTitle("发表评论", for: .normal)
        commitButton?.backgroundColor = JHBaseLightGrayColor
        commitButton?.layer.cornerRadius = 4.0
        commitButton?.layer.masksToBounds = true
        commitButton?.addTarget(self, action: #selector(EditCommentContentView.commitButtonClick), for: .touchUpInside)
        self.bgView!.addSubview(commitButton!)
        
        
        _ = editTextView?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.bgView?.mas_left)?.offset()(15)
            _ = make?.right.equalTo()(weakSelf?.bgView?.mas_right)?.offset()(-15)
            _ = make?.top.equalTo()(weakSelf?.bgView?.mas_top)?.offset()(5)
            _ = make?.height.mas_equalTo()(80)
        })
        
        
        _ = commitButton?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.editTextView?.mas_bottom)?.offset()(5)
            _ = make?.left.right().equalTo()(weakSelf?.editTextView)
            _ = make?.height.mas_equalTo()(30)
        })
        
        self.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(EditCommentContentView.keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    public func showAnimation() ->Void{
        editTextView?.becomeFirstResponder()
    }
    
    
    func keyBoardWillShow(notification:Notification) -> Void {
        
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        height = -value.cgRectValue.size.height
        
        let value2 = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let during = value2.doubleValue
        weak var weakSelf = self
        
        
//        
//        self.bgView?.setNeedsUpdateConstraints()
//        self.bgView?.updateConstraintsIfNeeded()
//        
        _ = self.bgView?.mas_updateConstraints({ (make) in
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
        })
        UIView.animate(withDuration: 0.2) {
            weakSelf?.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0.5)
            weakSelf?.layoutIfNeeded()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func hideSelf() -> Void {
        self.editTextView?.resignFirstResponder()
        weak var weakSelf = self
        height = CGFloat(195)
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.backgroundColor = JHColor(r: 37, g: 38, b: 48, a: 0)
            weakSelf?.bgView?.mas_updateConstraints({ (make) in
                make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()((weakSelf?.height)!)
            })
            weakSelf?.layoutIfNeeded()
            
            }, completion: { (finish) in
                if finish{
                    weakSelf?.editTextView?.text = ""
                    weakSelf?.removeFromSuperview()
                }
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let p = touches.first?.location(in: self)
        if (p?.y)!<(self.bgView?.frame.origin.y)!{
            
            
            hideSelf()
            
        }
        
    }
    
    
}


















