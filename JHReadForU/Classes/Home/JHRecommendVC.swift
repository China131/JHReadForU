//
//  JHRecommendVC.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/15.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHRecommendVC: JHBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView?
    var headerView:JHRecommendHeaderView?
    var hotBookCategoryArray:[BookCategoryModel]?
    var hotBookArray:[BookModel]?
    var lastBookArray:[BookModel]?
    var guessFavorite:[BookModel]?
    let sectionTitleArray = ["热门分类","热门书籍","最新出版","猜你喜欢","最近活动"]
    let sectionImageList = ["定制","热门","品牌出版","",""]
    let sectionSubTitle = ["定制热门","查看更多","出版频道","大海捞针","活动页面"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabBarControllerNavigationTitle(title: "精品推荐")
        tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = false
        tableView?.register(JHScrollViewCell.classForCoder(), forCellReuseIdentifier: "ScrollViewCell")
        tableView?.register(UINib.init(nibName: "BookShowUnTotalCell", bundle: nil), forCellReuseIdentifier: "BookShow")
        self.view.addSubview(tableView!)
        weak var weakSelf = self
        _ = tableView?.mas_makeConstraints({ (make) in
            _ = make?.top.equalTo()(weakSelf?.view.mas_top)?.offset()(64)
            _ = make?.left.right().equalTo()(weakSelf?.view)
            _ = make?.bottom.mas_equalTo()(-49)
        })
        
        headerView = JHRecommendHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: UISCREEN_WIDTH, height: 270+31))
        tableView?.tableHeaderView = headerView!
        headerView?.imageClickBlock = {modle -> Void in
            let mod = modle as! ADModel
            let webVC = JHWebViewVC()
            webVC.url = mod.url!
            weakSelf?.rootNavigationController().pushViewController(webVC, animated: true)
        }
        configBaseData()
    }

    
    
    func configBaseData() -> Void {
        weak var weakSelf = self
        MainUtil().hotCategoryRequest(successHandler: { (array) in
            weakSelf?.hotBookCategoryArray = array as! [BookCategoryModel]
            weakSelf?.tableView?.reloadSections([0], with: .none)
        } ,failHandler: { (error) in
            
        })
        
        MainUtil().hotBookRequest(successHandler: { (array) in
            weakSelf?.hotBookArray = array as! [BookModel]
            weakSelf?.tableView?.reloadSections([1], with: .none)
            },failHandler:  { (error) in
                
        })
        
        MainUtil().lastBookRequest(successHandler: { (array) in
            weakSelf?.lastBookArray = array as! [BookModel]
            weakSelf?.tableView?.reloadSections([2], with: .none)
            },failHandler: { (error) in
                
        })
        
        MainUtil().guessYourFavoriteBookRequest(successHandler: { (array) in
            weakSelf?.guessFavorite = array as! [BookModel]
            weakSelf?.tableView?.reloadSections([3], with: .none)
            },failHandler:  { (error) in
                
        })
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if hotBookCategoryArray != nil{
                return 1
            }
            return 0

        case 1:
            if hotBookArray != nil{
                return 1
            }
            return 0

        case 2:
            if lastBookArray != nil{
                return 1
            }
            return 0

        case 3:
            if guessFavorite != nil{
                return 1
            }
            return 0

        default:
            return 0
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 75

        case 1:
            return 160

        case 2:
            return 160

        case 3:
            return 160

        default:
            break
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollViewCell") as! JHScrollViewCell
            cell.dataSources = hotBookCategoryArray
            
            return cell
          
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookShow") as! BookShowUnTotalCell
            cell.bookArray = hotBookArray
            cell.viewClickBlock = { (index) in
                
                let i = index as! Int
                let model:BookModel = (weakSelf?.hotBookArray![i])!
                let vc = JHBookDetailVC()
                vc.model = model
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell

            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookShow") as! BookShowUnTotalCell
            cell.bookArray = lastBookArray
            cell.viewClickBlock = { (index) in
                
                let i = index as! Int
                let model:BookModel = (weakSelf?.lastBookArray![i])!
                let vc = JHBookDetailVC()
                vc.model = model
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookShow") as! BookShowUnTotalCell
            cell.bookArray = guessFavorite
            cell.viewClickBlock = { (index) in
                
                let i = index as! Int
                let model:BookModel = (weakSelf?.guessFavorite![i])!
                let vc = JHBookDetailVC()
                vc.model = model
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell

            
        default: break
            
        }
        
        
        return UITableViewCell.init()
    }
    
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionHeaderView.init(title: sectionTitleArray[section], buttonTitle: sectionSubTitle[section], buttonImageName: sectionImageList[section])
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y>80&&scrollView.contentOffset.y<=160 {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 160), animated: true)
        }else if scrollView.contentOffset.y<80{
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
    
    
    
    

    
    
    
    
    

}
