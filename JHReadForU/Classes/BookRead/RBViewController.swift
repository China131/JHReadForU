//
//  RBViewController.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/12/2.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class RBViewController: JHBaseViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var presentLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    var currentText:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = currentText
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    convenience init() {
        var nibNameOrNil = String?("RBViewController")//这里根据自己xib名

        self.init(nibName: nibNameOrNil, bundle: nil)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
