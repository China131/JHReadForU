//
//  JHFlowView.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/16.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit






class JHFlowView: UICollectionView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var dataSourceArray:[BookCategoryModel]?{
        didSet{
            
            self.reloadData()
            
        }
    }
    
    func showView() -> Void {
        
        
        
        
        
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = JHCustomeFlow.init()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.showsVerticalScrollIndicator = false
        self.register(UINib.init(nibName: "JHFlowItemCell", bundle: nil), forCellWithReuseIdentifier: "flowCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSourceArray==nil{
            return 0
        }
        return (dataSourceArray?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSourceArray?[indexPath.row]
        let str:NSString =  NSString.init(string: (model?.typeName)!)
        var size = str.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH, height: 30), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context:nil).size
        size.height = 30
        size.width += 20
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flowCell", for: indexPath) as! JHFlowItemCell
        let model = dataSourceArray?[indexPath.row]
        cell.contentLabel.text = model?.typeName
        cell.contentLabel.backgroundColor = JHColor(r: CGFloat(20) + CGFloat(arc4random()%236), g: CGFloat(20) + CGFloat(arc4random()%236), b: CGFloat(20) + CGFloat(arc4random()%236), a: 0.7)
        return cell
        
        
    }
  
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    

}
