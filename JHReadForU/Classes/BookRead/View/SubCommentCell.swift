//
//  SubCommentCell.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/22.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class SubCommentCell: UITableViewCell {
    var model:SubCommentModel?{
        
        didSet{
            if model==nil{
                return
            }
            weak var weakSelf = self
            headButton.setTitle(model?.FromID?.userName!, for: .normal)
            headButton.mas_updateConstraints { (make) in
                _ = make?.height.mas_equalTo()(weakSelf?.model!.nameHeight)
            }
            contentLabel.text = model?.content!
            self.setNeedsDisplay()
        }
        
    }
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var headButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func headClick(_ sender: AnyObject) {
        
        
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let contex = UIGraphicsGetCurrentContext() else {
            return
        }
        
        guard let md = self.model else {
            return
        }
        
        
        
        
        //        contex
        if (self.model?.isLastObject)!{
            contex.move(to: CGPoint.init(x: 15, y: (self.model?.height)! + 16 - 1))
            
//            let ss:[CGFloat] = [4,2]
//            contex.setLineDash(phase: CGFloat(1),lengths: ss)
            contex.addLine(to: CGPoint.init(x: UISCREEN_WIDTH, y: (self.model?.height)! + 16 - 1))
            contex.setStrokeColor(JHBaseBackGroundColor.cgColor)
            contex.drawPath(using: .fillStroke)
        }
        
        
    }
    

}
