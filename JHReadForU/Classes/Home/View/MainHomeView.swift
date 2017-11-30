//
//  MainHomeView.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/15.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class HomeHeadView: UIView {
    var iconImageView:UIButton?
    var titleLabel:UILabel?
    var searchButton:UIButton?
    var addButton:UIButton?
    var headIconClickBlock:JHBlockWithNoneParamter?
    func iconClick() -> Void {
        
        if let v = headIconClickBlock {
            v()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = JHBaseLightGrayColor
        
        iconImageView = UIButton.init(type:.custom)
        iconImageView?.layer.cornerRadius = 20
        iconImageView?.layer.masksToBounds = true
        iconImageView?.addTarget(self, action: #selector(HomeHeadView.iconClick), for: .touchUpInside)
        self.addSubview(iconImageView!)
        
        titleLabel = UILabel.init()
        titleLabel?.text = "我的书架"
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = UIColor.white
        self.addSubview(titleLabel!)
        
        searchButton = UIButton.init(type: .custom)
        searchButton?.setImage(UIImage.init(named: "搜索"), for: .normal)
        self.addSubview(searchButton!)
        
        addButton = UIButton.init(type: .custom)
        addButton?.setImage(UIImage.init(named: "添加"), for: .normal)
        self.addSubview(addButton!)
        
        weak var weakSelf = self
        _ = iconImageView?.mas_makeConstraints({ (make) in
            _ = make?.left.mas_equalTo()(15)
            _ = make?.bottom.equalTo()(weakSelf?.mas_bottom)?.offset()(-5)
            _ = make?.width.height().mas_equalTo()(40)
            
        })
        
        _ = titleLabel?.mas_makeConstraints({ (make) in
            _ = make?.centerX.equalTo()(weakSelf?.mas_centerX)
            _ = make?.centerY.equalTo()(weakSelf?.iconImageView?.mas_centerY)
        })
        
        _ = addButton?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.mas_right)?.offset()(-10)
            _ = make?.centerY.equalTo()(weakSelf?.iconImageView?.mas_centerY)
            _ = make?.width.height().mas_equalTo()(20)
        })
        
        _ = searchButton?.mas_makeConstraints({ (make) in
            _ = make?.right.equalTo()(weakSelf?.addButton?.mas_left)?.offset()(-10)
            _ = make?.centerY.equalTo()(weakSelf?.iconImageView?.mas_centerY)
            _ = make?.width.height().equalTo()(weakSelf?.addButton)
        })
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class MainHomeView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var itemSelectedHandler:JHRequestBlock?
    var headerView:HomeHeadView?
    var contentView:UICollectionView?
    var bookDataSorce:[BookModel]?
    var bookSpace = CGFloat(30)
    let itemSize:CGSize = CGSize.init(width: (UISCREEN_WIDTH - 30 * CGFloat(4)) / 3.0, height: (UISCREEN_WIDTH - 30 * CGFloat(4)) / 3.0 * 4 / 3 + 35)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerView = HomeHeadView.init(frame: CGRect.init())
        
        self.addSubview(headerView!)
        
        _ = headerView?.mas_makeConstraints({ (make) in
            _ = make?.top.right().left().mas_equalTo()(0)
            _ = make?.height.equalTo()(64)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainHomeView.dataSourceRequest), name: NSNotification.Name(rawValue: JHBookListViewReloadDataSource), object: nil)
        
        let flow = JHCustomeFlow.init()
        flow.minimumLineSpacing = bookSpace
        flow.minimumInteritemSpacing = bookSpace
        flow.maxSpace = bookSpace
        dataSourceRequest()
        
        contentView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: flow)
        contentView?.dataSource = self
        contentView?.delegate = self
        contentView?.backgroundColor = UIColor.clear
        contentView?.register(UINib.init(nibName: "JHBookListItem", bundle: nil), forCellWithReuseIdentifier: "BookList")
        self.addSubview(contentView!)
        weak var weakSelf = self
        _ = contentView?.mas_makeConstraints({ (make) in
            _ = make?.left.right().bottom().equalTo()(weakSelf)
            _ = make?.top.equalTo()(weakSelf?.mas_top)?.offset()(64)
        })
    }
    
    func dataSourceRequest() -> Void {
        bookDataSorce = JHDataBaseManager.manager.currentBookList()
        contentView?.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
        return  bookDataSorce == nil ? 0:(bookDataSorce?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookList", for: indexPath) as! JHBookListItem
        cell.model = bookDataSorce?[indexPath.row]
        weak var weakCell = cell
        cell.model?.weakCell = weakCell?.imageViews
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: bookSpace, left: bookSpace, bottom: bookSpace, right: bookSpace)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemSelectedHandler == nil ? () : itemSelectedHandler!(bookDataSorce?[indexPath.row])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
}
