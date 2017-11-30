//
//  JHFlowItemCell.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/16.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHFlowItemCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.layer.cornerRadius = 4.0
        contentLabel.layer.masksToBounds = true
        // Initialization code
    }

}
