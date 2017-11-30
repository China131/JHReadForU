//
//  MainUtil.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/14.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import AFNetworking
class MainUtil: NSObject {

    public func userInfoRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock)->Void{
        
        let bquery = BmobQuery(className: "_User")
        bquery?.whereKey("username", equalTo: "李梦琪")
        bquery?.findObjectsInBackground({ (array, error) in
            let arr = array as! Array<BmobObject>
            
            for obj in arr{
                weak var app = UIApplication.shared.delegate as? AppDelegate
                app?.userInfo = UserModel.init(object: obj)
                successHandler(app?.userInfo)
                return
                
            }
            
            failHandler("")
            
        })
    }
    
    public func adInfoRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock)->Void{
        let bauery = BmobQuery(className: "AD")
        bauery?.findObjectsInBackground({ (array, error) in
            
            let arr = array as! Array<BmobObject>
            var cacheArray:[ADModel] = Array.init()
            for obj in arr{
                let model = ADModel.init(object: obj)
                cacheArray.append(model)
            }
            successHandler(cacheArray)

        })
    }
    
    
    public func hotCategoryRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock) ->Void{
        let baquery = BmobQuery(className: "BookCategory")
        baquery!.order(byDescending: "RequestCount")
        baquery?.limit = 8
        baquery?.findObjectsInBackground({ (array, error) in
            
            if error != nil{
                failHandler("")
                return
            }
            let arr = array as! Array<BmobObject>
            var cacheArray:[BookCategoryModel] = Array.init()
            
            for obj in arr{
                let model = BookCategoryModel.init(object: obj)
                cacheArray.append(model)
            }
            successHandler(cacheArray)
        })
        
    }
    
    
    
    public func hotBookRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock) ->Void{
        let baquery = BmobQuery(className: "Book_List")
        baquery?.order(byDescending: "DownloadCount")
        baquery?.limit = 3
        baquery?.findObjectsInBackground({ (array, error) in
            
            if error != nil{
                failHandler(error!)
                return
            }
            
            let arr = array as! Array<BmobObject>
            var cacheArray:[BookModel] = Array.init()
            
            for obj in arr{
                
                let model = BookModel.init(object: obj)
                cacheArray.append(model)
                
            }
            successHandler(cacheArray)
            
            
        })
    }
    
    public func lastBookRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock) ->Void{
        let baquery = BmobQuery(className: "Book_List")
        baquery?.order(byDescending: "createdAt")
        baquery?.limit = 3
        baquery?.findObjectsInBackground({ (array, error) in
            
            if error != nil{
                failHandler(error!)
                return
            }
            
            let arr = array as! Array<BmobObject>
            var cacheArray:[BookModel] = Array.init()
            
            for obj in arr{
                
                let model = BookModel.init(object: obj)
                cacheArray.append(model)
                
            }
            successHandler(cacheArray)
            
            
        })
    }

    public func guessYourFavoriteBookRequest(successHandler:@escaping JHRequestBlock,failHandler:@escaping JHRequestBlock) ->Void{
        let baquery = BmobQuery(className: "Book_List")
        baquery?.order(byDescending: "createdAt")
        baquery?.limit = 100
        baquery?.findObjectsInBackground({ (array, error) in
            
            if error != nil{
                failHandler(error!)
                return
            }
            
            let arr = array as! Array<BmobObject>
            var cacheArray:[BookModel] = Array.init()
            
            var numberArr:[Int] = Array.init()
            
            if arr.count>3{
            
                while numberArr.count<3{
                    let index = Int(arc4random()) % arr.count
                    if numberArr.contains(index){
                        continue
                    }else{
                        let model = BookModel.init(object: arr[index])
                        cacheArray.append(model)
                        numberArr.append(index)
                    }
                }
            }else{
                
                for obj in arr{
                    
                    let model = BookModel.init(object: obj)
                    cacheArray.append(model)
                    
                }
                
            }
            successHandler(cacheArray)
            
            
        })
    }

    
    public func addCommentRequest(bookID:String ,string:String,score:Int,successHandler:@escaping JHRequestBlock,failure:@escaping JHRequestBlock)->Void{
        
        
        let bquery = BmobQuery.init(className: "Book_List")
        bquery?.whereKey("objectId", equalTo: bookID)
        bquery?.getObjectInBackground(withId: bookID, block: { (obj, errpr) in
            if errpr != nil{
                
            }else{
                
                var equallScore = (obj?.object(forKey: "rate") as! NSNumber).floatValue
                let count = (obj?.object(forKey: "bookCommentCount") as! NSNumber).floatValue
                
                equallScore = (Float(score * 20) - equallScore) / Float(count + 1) + equallScore
                obj?.setObject(NSNumber.init(value: equallScore), forKey: "rate")
                obj?.setObject(NSNumber.init(value: Int(count) + 1 ), forKey: "bookCommentCount")
                obj?.updateInBackground(resultBlock: { (finish, error) in
                    
                    if error==nil{
                        
                        
                    }
                    
                })

            }
        })
       
        
        
        let comment:BmobObject = BmobObject.init(className: "Comment")
        comment.setObject(string, forKey: "content")
        comment.setObject(NSNumber.init(value: score * 20), forKey: "commentScore")
        comment.setObject(bookID, forKey: "bookID")
        comment.setObject(NSNumber.init(value: 0), forKey: "favoriteCount")
        let author = BmobUser.init(outDataWithClassName: "_User", objectId: (UIApplication.shared.delegate as! AppDelegate).userInfo?.userID)
        
        comment.setObject(author, forKey: "UserID")
        comment.saveInBackground { (finish, error) in
            
            if let e = error {
                failure("")
                
            }else{
                
                successHandler("")
            }
            
        }
        
    }
    
    
    
    
    
    public func commentRequest(bookID:String,index:Int,successHandler:@escaping JHRequestBlock,failureHandler:@escaping JHRequestBlock)->Void{
        

        
        var bq = BmobQuery.init(className: "Comment")
        bq?.includeKey("UserID")
        bq?.order(byDescending: "createdAt")
        bq?.whereKey("bookID", equalTo: bookID)
        

        bq?.findObjectsInBackground({ (array, error) in
            if error != nil{
                failureHandler(error!.localizedDescription)
            }
            
            let arr = array as! [BmobObject]
            var cacheArray:[BookCommentModel] = Array.init()
            var subCacheArray:[SubCommentModel] = Array.init()
            
            let group = DispatchGroup.init()
            
            for obj in arr{
                group.enter()
                cacheArray.append(BookCommentModel.init(object: obj))
                
                let Ratelation = BmobObject.init(outDataWithClassName: "Comment", objectId: obj.objectId)
                bq = BmobQuery.init(className: "SubComment")
                bq?.includeKey("FromID")
                bq?.whereObjectKey("subComment", relatedTo: Ratelation)
                bq?.findObjectsInBackground({ (sub, error) in
                    
                    if (error != nil) {
                        group.leave()
                    }else{
                        let subArray = sub as! [BmobObject]
                        for subObj in subArray{
                            subCacheArray.append(SubCommentModel.init(obj: subObj))
                        }
                        group.leave()
                    }
                    
                })
            }
            
            group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { 
                let sub = NSArray.init(array: subCacheArray)
                let allArray = NSMutableArray.init()
                for i in 0..<cacheArray.count{
                    let model = cacheArray[i]
                    let predicate = NSPredicate.init(format: "CommentID=%@", model.commentID!)
                    let result = sub.filtered(using: predicate)
                    model.subCommentCount = result.count
                    if result.count == 0{
                        model.haveSubComment = false
                    }else{
                        let last = result.last as! SubCommentModel
                        last.isLastObject = true
                        model.haveSubComment = true
                    }
                    allArray.add(model)
                    allArray.addObjects(from: result)
                }
                successHandler(allArray)

            }))
            

        })
        
        
    }
    
    
    
    
    
    
    
    
}
































