//
//  JHCustomeFlow.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/16.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit






class JHCustomeFlow: UICollectionViewFlowLayout {
    
    var maxSpace = CGFloat(10)
    
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
       
        
        let attributes:[UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
         print(maxSpace)
        for i in 0..<(attributes.count) {
            let currentLayoutAttributes = attributes[i]
            if i==0 {
                var frame = currentLayoutAttributes.frame
                frame.origin.x = maxSpace
                currentLayoutAttributes.frame = frame
                continue
            }
            let prevLayoutAttrubutes = attributes[i-1]
            let maximumSpacing:CGFloat = maxSpace
            
            let origin = prevLayoutAttrubutes.frame.origin.x + prevLayoutAttrubutes.frame.size.width
            
            if origin + maximumSpacing + currentLayoutAttributes.frame.size.width < rect.size.width {
                
                var ff = currentLayoutAttributes.frame
                ff.origin.x = origin+maximumSpacing
                ff.origin.y = prevLayoutAttrubutes.frame.origin.y
                currentLayoutAttributes.frame = ff
                
            }else{
                
                var ff = currentLayoutAttributes.frame
                ff.origin.x = maximumSpacing
                currentLayoutAttributes.frame = ff
            }
            

            
        }
        return attributes
        
    }

}























