//
//  JHBookListItem.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/12/1.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHBookListItem: UICollectionViewCell {
    var model : BookModel?{
        
        didSet{
            nameLabel.text = model?.book_name!
            
            if model?.book_CoverIcon != nil && model?.book_CoverIcon?.url != nil && model?.book_CoverIcon?.url != ""{

                imageViews.sd_setImage(with: URL.init(string: (model?.book_CoverIcon?.url!)!))

            }else{
                imageViews.image = UIImage.init(named: "书籍默认封面")
            }
            
            
        }
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
