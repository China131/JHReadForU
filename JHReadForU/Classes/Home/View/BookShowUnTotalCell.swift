//
//  BookShowUnTotalCell.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/16.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import SDWebImage
class BookShowUnTotalCell: UITableViewCell {

    var viewClickBlock:JHRequestBlock?
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    
    var bookArray:[BookModel]?{
        
        didSet{
            
            if bookArray==nil {
                return
            }
            
            let viewArray = [leftView,midView,rightView]
            for i in 0..<bookArray!.count{
                
                let currentView = viewArray[i]
                let model = bookArray![i]
                let imageFile = model.book_CoverIcon
                let currentImageView:UIImageView = currentView?.viewWithTag(100) as! UIImageView
                let currentLabel:UILabel = currentView?.viewWithTag(101) as! UILabel
                currentImageView.sd_cancelCurrentImageLoad()
                currentImageView.image = nil
                if imageFile?.url != nil{
                    currentImageView.sd_setImage(with: URL.init(string: (imageFile?.url)!)!)
                   
                }else{
                     currentImageView.image = UIImage.init(named: "书籍默认封面")
                }
                currentLabel.text = ""
                currentLabel.text = model.book_name
                
            }
            
        }
    }
    
    
    func tapClick(tapG:UITapGestureRecognizer) -> Void {
        
        let currentV = tapG.view
        
        if viewClickBlock==nil{
            return
        }
        
        if currentV==leftView{
            
            viewClickBlock!(0)
//            print("left")
        }else if currentV==midView{
            viewClickBlock!(1)
//            print("mid")
        }else if currentV==rightView{
            viewClickBlock!(2)
//            print("right")
        }
        
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(BookShowUnTotalCell.tapClick(tapG:)))
        leftView.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(BookShowUnTotalCell.tapClick(tapG:)))
        midView.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(BookShowUnTotalCell.tapClick(tapG:)))
        rightView.addGestureRecognizer(tapGesture3)
    
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
