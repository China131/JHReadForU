//
//  JHBookDetailVC.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/16.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHBookDetailVC: JHBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var model:BookModel?
    var tableView:UITableView?
    var tableViewHeaderView:TableViewHeader?
    var commentView:WriteCommentView?
    var _editCommentView:EditCommentContentView?
    var commentArray:[AnyObject]?
    var _subCommentView:SubEditCommentContentView?
    var currentCommentID:String?
    var subCommentView:SubEditCommentContentView?{
        set{
            _subCommentView = newValue
        }
        
        get{
            if _subCommentView == nil {
                _subCommentView = SubEditCommentContentView.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: UISCREEN_HEIGHT))
               
            }
            
            return _subCommentView
        }
    }
    
    var editCommentView:EditCommentContentView?{
        
        set{
            _editCommentView = newValue
        }
        
        get{
            
            if _editCommentView == nil{
                _editCommentView = EditCommentContentView.init(frame: CGRect.init())
            }
            
            return _editCommentView
        }
        
    }
    
    
    func downLoadBook() -> Void {
        
        BookDownloadManager.manager.download(model: model!)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleWithString(title: "书籍详情")
        tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.register(UINib.init(nibName: "JHCommentCell", bundle: nil), forCellReuseIdentifier: "Comment")
        tableView?.register(UINib.init(nibName: "SubCommentCell", bundle: nil), forCellReuseIdentifier: "SubComment")
        self.view.addSubview(tableView!)
        commentArray = Array.init()
        configBaseData()
        weak var weakSelf = self
        _ = tableView?.mas_makeConstraints({ (make) in
            _ = make?.left.right().equalTo()(weakSelf?.view)
            _ = make?.bottom.equalTo()(weakSelf?.view.mas_bottom)?.offset()(-45)
            _ = make?.top.equalTo()(weakSelf?.view.mas_top)?.offset()(64)
        })
        
        let downloadButton = UIButton.init(type: .custom)
        downloadButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        downloadButton.setImage(UIImage.init(named: "下载"), for: .normal)
        downloadButton.addTarget(self, action: #selector(JHBookDetailVC.downLoadBook), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: downloadButton)
        
        tableViewHeaderView = TableViewHeader.init(model: model!)
        tableViewHeaderView?.frame = CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 340)
        tableView?.tableHeaderView = tableViewHeaderView
        tableView?.tableFooterView = UIView.init()
        tableView?.separatorStyle = .none
        commentView = WriteCommentView.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 175))
        commentView?.favoriteButton?.setTitle("\((model?.favorite?.intValue)!)", for: .normal)
        commentView?.editCommentClickHandler = { () in
           UIApplication.shared.keyWindow?.addSubview((weakSelf?.editCommentView)!)
           weakSelf?.editCommentView?.showAnimation()
           _ = weakSelf?.editCommentView?.mas_makeConstraints({ (make) in
             _ = make?.top.left().right().bottom().equalTo()(weakSelf?.view)
           })
        }
        commentView?.favoriteButtonHandler = { () in
            weakSelf?.bookFavorite()
            
        }
        commentView?.shareClickHandler = { () in
            weakSelf?.share()
            
        }
        editCommentView?.commitClickHandler = {(string:String,index:Int) in
            
            MainUtil().addCommentRequest(bookID: (weakSelf?.model?.bookID)!, string: string, score: index, successHandler: { (obj) in
                
                JHWorningAlert().showSuccessWithString(string: "评论成功!")
                weakSelf?.configBaseData()
                }, failure: { (error) in
                    JHWorningAlert().showWorningWithString(string:"评论失败!")
            })
            
        }
        self.view.addSubview(commentView!)
        
        _ = commentView?.mas_makeConstraints({ (make) in
            _ = make?.left.right().equalTo()(weakSelf?.view)
            _ = make?.bottom.equalTo()(weakSelf?.view.mas_bottom)
            _ = make?.height.mas_equalTo()(45)
        })
        // Do any additional setup after loading the view.
    }

    func share() -> Void {
        
        
        
    }
    
    func configBaseData() -> Void {
        weak var weakSelf = self
        MainUtil().commentRequest(bookID: (model?.bookID)!, index: 1, successHandler: { (array) in
            
            weakSelf?.commentArray = array as! [AnyObject]

            weakSelf?.tableView?.reloadSections([0], with: .none)
            
            },failureHandler: { (error) in
                
        })
        
    }
    
    
    //书籍点赞
    func bookFavorite() -> Void {
        weak var weakSelf = self
        BookDetailUtil().bookFavoriteAddRequest(bookID: (model?.bookID)!, successHandler: { (obj) in
          weakSelf?.commentView?.favoriteButton?.setTitle("\(obj as! Int)", for: .normal)
            
            },failrueHandler:  { (error) in
                
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (commentArray?.count)!
        default:
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0.1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            
            var model = commentArray?[indexPath.row]
            if (model?.isKind(of: BookCommentModel.classForCoder()))! {
                let mod = model as! BookCommentModel
                if mod.haveSubComment!{
                    return  CGFloat(Int((mod.height)!)) + 100 + 16 - 5 - 20
                }
                return CGFloat(Int((mod.height)!))  + 100 + 16 - 5
            }else{
                let mod = model as! SubCommentModel
                return 16 + CGFloat(Int(mod.height!)) + 1
            }
            
        default:
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mod = commentArray?[indexPath.row]
        
        
        if (mod?.isKind(of: BookCommentModel.classForCoder()))!{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment") as! JHCommentCell
            cell.model = commentArray?[indexPath.row] as! BookCommentModel
            cell.selectionStyle = .none
            weak var weakSelf = self
            //弹出二级评论编辑界面
            cell.commentHandler = { (model) in
                weakSelf?.currentCommentID = model.commentID
                UIApplication.shared.keyWindow?.addSubview((weakSelf?.subCommentView!)!)
                
                _ = weakSelf?.subCommentView?.mas_makeConstraints({ (make) in
                    _ = make?.top.left().right().bottom().equalTo()(weakSelf?.view)
                })
                weakSelf?.subCommentView?.showAnimation()
                weakSelf?.subCommentView?.editTextView?.text = "@\((model.userInfo?.userName!)!) "
                
                weakSelf?.subCommentView?.commitClickHandler = {(string:String,index:Int) in
                    BookDetailUtil().subCommentAddRequest(content: string, fromID: APP_USERID!, toCommentID: (weakSelf?.currentCommentID)!, successHandler: { (obj) in
                        
                        JHWorningAlert().showSuccessWithString(string: "评论成功!")
                        weakSelf?.configBaseData()
                        }, failure: { (error) in
                            JHWorningAlert().showWorningWithString(string:"评论失败!")
                    })
                    
                }
                
            }
            
            
            //点赞操作
            cell.favoriteClickHandler = { (model) in
                BookDetailUtil().favoriteAddRequest(commentID: model.commentID!, successHandler: { (count) in
                    
                    model.favoriteCount = NSNumber.init(value: count as! Int)
                    weakSelf?.tableView?.reloadRows(at: [indexPath], with: .none)
                    
                    }, failrueHandler: { (error) in
                        
                })
                
                
            }
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubComment") as! SubCommentCell
            cell.model = commentArray?[indexPath.row] as! SubCommentModel
            
            return cell
        }
        
        
        
    }
    
    
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
            break
            
        case 1:
            break
        default:
            break
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return SectionHeaderView.init(title: "评论", buttonTitle: "", buttonImageName: "")
            break
            
        case 1:
            break
        default:
            break
        }
        return nil
    }
}
