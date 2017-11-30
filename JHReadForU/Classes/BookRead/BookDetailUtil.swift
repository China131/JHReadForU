//
//  BookDetailUtil.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/21.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class BookDetailUtil: NSObject {

    func subCommentAddRequest(content:String,fromID:String,toCommentID:String,successHandler:@escaping JHRequestBlock,failure:@escaping JHRequestBlock) -> Void {
        let commentOBJ = BmobObject.init(outDataWithClassName: "Comment", objectId: toCommentID)
        let obj = BmobObject.init(className: "SubComment")
        obj?.setObject(content, forKey: "Content")
        let author = BmobUser.init(outDataWithClassName: "_User", objectId: fromID)
        obj?.setObject(author, forKey: "FromID")
        obj?.setObject(toCommentID, forKey: "CommentID")
        obj?.saveInBackground(resultBlock: { (success, error) in
            if success{
                let relation = BmobRelation.init()

                relation.add(obj)
                commentOBJ?.add(relation, forKey: "subComment")
                commentOBJ?.updateInBackground(resultBlock: { (success, error) in
                    
                    if !success {
                        successHandler("")
                        return
                    }
                    
                    successHandler("")

                })
                

            }
            
        })
        }
    
    func favoriteAddRequest(commentID:String,successHandler:@escaping JHRequestBlock,failrueHandler:@escaping JHRequestBlock) -> Void {
       let bq = BmobQuery.init(className: "Comment")
       bq?.getObjectInBackground(withId: commentID, block: { (object, error) in
        
        if error != nil{
            
            failrueHandler("")
        }
        
        var count = object?.object(forKey: "favoriteCount") as! NSNumber
        
        count == nil ? (count = NSNumber.init(value: 0)):()
        
        var change = count.intValue
        
        change += 1
        object?.setObject(NSNumber.init(value: change), forKey: "favoriteCount")
        
        object?.updateInBackground(resultBlock: { (success, error) in
            success ? (successHandler(change)):(failrueHandler(""))
        })
        
       })

    }
    
    func bookFavoriteAddRequest(bookID:String,successHandler:@escaping JHRequestBlock,failrueHandler:@escaping JHRequestBlock) -> Void {
        
        let bj = BmobObject.init(className: "FavoriteBook")
        bj?.setObject(APP_USERID, forKey: "UserID_S")
        bj?.setObject(bookID, forKey: "BookID")
        bj?.saveInBackground()
        
        let bq = BmobQuery.init(className: "Book_List")
        bq?.getObjectInBackground(withId: bookID, block: { (object, error) in
            
            if error != nil{
                failrueHandler("")
                return
            }
            
            var count = object?.object(forKey: "favorite") as! NSNumber
            if count == nil{
                count = NSNumber.init(value: 0)
            }
            
            var change = count.intValue + 1
            object?.setObject(NSNumber.init(value: change), forKey: "favorite")
            object?.updateInBackground(resultBlock: { (success, errors) in
                if success {
                    successHandler(change)
                }else{
                    failrueHandler(error.debugDescription)
                }
            })
            
            
        })
        
        
    }
    
}
