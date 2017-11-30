//
//  UserModel.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/14.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    var userName:String?
    var passWord:String?
    var level:NSNumber?
    var avastar:BmobFile?
    var email:String?
    var userID:String?
    init(object:BmobObject) {
        super.init()
        userName = object.object(forKey: "username") as! String?
        passWord = object.object(forKey: "password") as! String?
        level = object.object(forKey: "level") as! NSNumber?
        avastar = object.object(forKey: "avastar") as! BmobFile?
        userID = object.object(forKey: "objectId") as! String?
    }
    
}



class ADModel: NSObject {
    var url:String?
    var cover:BmobFile?
    init(object:BmobObject) {
        super.init()
        url = object.object(forKey: "url") as! String?
        cover = object.object(forKey: "cover") as! BmobFile?
        
    }
}


class BookCategoryModel: NSObject {
    var typeName:String?
    var TypeCode:NSNumber?
    var RequestCount:NSNumber?
    var objectID:String?
    
    init(object:BmobObject) {
        super.init()
        typeName = object.object(forKey: "typeName") as! String?
        TypeCode = object.object(forKey: "TypeCode") as! NSNumber?
        RequestCount = object.object(forKey: "RequestCount") as! NSNumber?
        objectID = object.object(forKey: "objectID") as! String?
    }
    
    override init() {
        super.init()
    }
}


class BookModel: NSObject {
    var DownloadCount:NSNumber?
    var category:String?
    var book_State:NSNumber?
    var book_name:String?
    var book_file:BmobFile?
    var book_CoverIcon:BmobFile?
    var vote:NSNumber? //投票
    var favorite:NSNumber?//点赞
    var rate:NSNumber?//评价评价得分
    var bookCommentCount:NSNumber?
    var book_Maker:String?
    var bookID:String?
    var saveIndex:Int = 0
    var weakCell:UIImageView?
    var book_ChapterCount:Int?
    var _introduction:String?
    var introduction:String?{

        set{
            if newValue==nil{
                _introduction = "暂无简介"
            }else{
                _introduction = newValue
            }
        }
        get{
            return _introduction
        }
    }
    
    override init() {
        super.init()
    }
    init(object:BmobObject) {
        super.init()
        category = object.object(forKey: "category") as! String?
        DownloadCount = object.object(forKey: "DownloadCount") as! NSNumber?
        book_State = object.object(forKey: "book_State") as! NSNumber?
        book_name = object.object(forKey: "book_name") as! String?
        book_file = object.object(forKey: "book_file") as! BmobFile?
        book_CoverIcon = object.object(forKey: "book_CoverIcon") as! BmobFile?
        vote = object.object(forKey: "vote") as! NSNumber?
        favorite = object.object(forKey: "favorite") as! NSNumber?
        rate = object.object(forKey: "rate") as! NSNumber?
        bookCommentCount = object.object(forKey: "bookCommentCount") as! NSNumber?
        book_Maker = object.object(forKey: "book_Maker") as! String?
        introduction = object.object(forKey: "introduction") as! String?
        bookID = object.object(forKey: "objectId") as! String?
    }
}



class BookCommentModel: NSObject {
    
    var commentID:String?
    var content:String?
    var UserName:String?
    var subCommentCount:Int?
    var bookID:String?
    var createdAt:String?
    var commentScore:NSNumber?
    var favoriteCount:NSNumber?
    var height:CGFloat?
    var userInfo:UserModel?
    var favorite:BmobRelation?
    var haveSubComment:Bool?
    init(object:BmobObject) {
        super.init()
        commentID = object.object(forKey: "objectId") as! String?
        content = object.object(forKey: "content") as! String?
        let userIn = object.object(forKey: "UserID") as! BmobObject?
        userInfo = UserModel.init(object: userIn!)
        let str = NSString.init(string: content!)
        
        height = str.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH - 25 - 16, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil).size.height
        
        if height! < CGFloat(25){
            height! = CGFloat(25)
        }
        
        UserName = object.object(forKey: "UserName") as! String?
        bookID = object.object(forKey: "bookID") as! String?
        createdAt = object.object(forKey: "createdAt") as! String?
        commentScore = object.object(forKey: "commentScore") as! NSNumber?
        favoriteCount = object.object(forKey: "favoriteCount") as! NSNumber?
        haveSubComment = false
    }
    
}


class SubCommentModel: NSObject {
    
    var content:String?
    var FromID:UserModel?
    var FromPerson:String?
    var CommentID:String?
    var height:CGFloat?
    var nameHeight:CGFloat?
    var nameLength:CGFloat?
    var isLastObject:Bool?
    init(obj:BmobObject) {
        super.init()
        content = obj.object(forKey: "Content") as! String?
        FromPerson = obj.object(forKey: "FromPerson") as! String?
        CommentID = obj.object(forKey: "CommentID") as! String?
        let info = obj.object(forKey: "FromID") as! BmobObject?
        FromID = UserModel.init(object: info!)
        let name = NSString.init(string: (FromID?.userName!)!)
        let size = name.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH - 30 - 16, height: 20), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size
        var length = CGFloat(0)
        var str:NSString = ""
        while length<size.width {
            str = NSString.init(format: " %@", str)
            length = str.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH - 30 - 16, height: 20), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size.width
        }
        nameLength = length
        content = String.init(format: "%@:%@", str,content!)
        height = content!.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH - 30 - 16, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size.height
        nameHeight = size.height
        isLastObject = false
    }
}








