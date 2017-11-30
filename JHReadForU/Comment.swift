//
//  Comment.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/14.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import Foundation

let UISCREEN_WIDTH = UIScreen.main.bounds.size.width
let UISCREEN_HEIGHT = UIScreen.main.bounds.size.height
let JHBaseLightGrayColor = UIColor.init(red: 20/256.0, green: 200/256.0, blue: 200/256.0, alpha: 1)
let JHBaseBackGroundColor = UIColor.init(red: 236/255.0, green: 237/255.0, blue: 242/255.0, alpha: 1)
let APP_USERID = (UIApplication.shared.delegate as! AppDelegate).userInfo?.userID



let JHBookListViewReloadDataSource = "JHBookListViewReloadDataSource"



func JHColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor.init(red: r/256, green: g/256, blue: b/256, alpha: a)
}

typealias JHBlockWithNoneParamter = () ->Void
typealias JHRequestBlock = (_ response:Any)->Void
typealias JHStringAndIntBlock = (_ string:String,_ index:Int)->Void
typealias JHCommentSubCellButtonClickBlock = (_ model:BookCommentModel) ->Void
