//
//  JHCommentCell.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/21.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHCommentCell: UITableViewCell {
    var commentHandler:JHCommentSubCellButtonClickBlock?
    var favoriteClickHandler:JHCommentSubCellButtonClickBlock?
    var model:BookCommentModel?{
        
        didSet{
            if model == nil{
                return
            }

            coverImageView.sd_cancelCurrentImageLoad()
            coverImageView.image = UIImage.init(named: "头像")
            if let str = model?.userInfo?.avastar?.url{
                
                coverImageView.sd_setImage(with: URL.init(string: str)!)
            }
            
            if let num = model?.favoriteCount{
                favoriteBtn.setTitle("\(num)", for: .normal)
            }else{
                favoriteBtn.setTitle("0", for: .normal)
            }
            commentBtn.setTitle("\((model?.subCommentCount)!)", for: .normal)
            nameLabel.text = (model?.userInfo?.userName)!
            numberLabel.text = (model?.createdAt)!
            contentLabel.text = (model?.content)!
            self.setNeedsDisplay()
            
        }
        
    }
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.layer.cornerRadius = 20.0
        coverImageView.layer.masksToBounds = true
    }

    @IBAction func commentClick(_ sender: UIButton) {
        
        (commentHandler != nil) ? commentHandler!(model!):()
        
    }
    
    @IBAction func favoriteClick(_ sender: AnyObject) {
        
        (favoriteClickHandler != nil) ? favoriteClickHandler!(model!):()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let contex = UIGraphicsGetCurrentContext() else {
            return
        }
        
        guard let md = self.model else {
            return
        }

        if (self.model?.haveSubComment)!{
            contex.move(to: CGPoint.init(x: 15, y: (self.model?.height)! + 16 + 100 - 5-1 - 20))

            let ss:[CGFloat] = [4,2]
            contex.setLineDash(phase: CGFloat(1),lengths: ss)
            contex.addLine(to: CGPoint.init(x: UISCREEN_WIDTH, y: (self.model?.height)! + 16 + 100 - 5-1 - 20))
        }else{
            contex.move(to: CGPoint.init(x: 15, y: (self.model?.height)! + 16 + 100 - 5-1))
            contex.addLine(to: CGPoint.init(x: UISCREEN_WIDTH, y: (self.model?.height)! + 16 + 100 - 5-1))
            
            
        }
        
        contex.setStrokeColor(JHBaseBackGroundColor.cgColor)
        contex.drawPath(using: .fillStroke)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
