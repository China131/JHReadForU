//
//  JHDataBaseManager.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/25.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import FMDB
class JHDataBaseManager: NSObject {

    static let manager = JHDataBaseManager.init()
    var db:FMDatabase?
    override init() {
        super.init()
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path.append("/ReadU.db")
        db = FMDatabase.init(path: path)
        if db == nil {
            return
        }
        if (db?.open())! {
            let sql = "Create table if not exists  Book_Chapter (id integer primary key autoincrement , Book_ID varchar,indexs integer not null, name varchar,content text)"
            let sql2 = "Create table if not exists  Book_BookList (id integer primary key autoincrement , Book_ID varchar,imageURL varchar, bookname varchar,ChapterCount integer)"
            if (db?.executeStatements(sql))! {
                print("创建表成功")
            }else{
                return
            }
            if (db?.executeStatements(sql2))! {
                print("创建表成功")
            }else{
                return
            }
        }
    }
    
    
    public func findChapter(chapterIndex:Int,bookID:String) ->NSString{
        let sql = "select content from Book_Chapter where Book_ID = ? and indexs = ?"
        let ret = db?.executeQuery(sql, withArgumentsIn: [bookID,chapterIndex])
        
        while (ret?.next())! {                        
            return NSString.init(string: (ret?.string(forColumn: "content"))!)
        }
        return ""
    }
    
    
    
    
    
    public func saveBook(bookModel:BookModel) ->Bool{
        let sql = "insert into Book_BookList (Book_ID,imageURL,bookname,ChapterCount) values (?,?,?,?)"
  
        return (db?.executeUpdate(sql, withArgumentsIn: [bookModel.bookID!,bookModel.book_CoverIcon?.url == nil ? "":(bookModel.book_CoverIcon?.url)!,bookModel.book_name!,bookModel.book_ChapterCount!]))!
    }
    
    
    public func isExistsBook(bookModel:BookModel) ->Bool{
        
        let sql = "select count (*) from Book_BookList where Book_ID = ?"
        let ret = db?.executeQuery(sql, withArgumentsIn: [bookModel.bookID!])
        
        while (ret?.next())! {
            if ret?.int(forColumnIndex: 0) == 0 {
                return false
            }else{
                return true
            }
            
        }
        
        return false
        
    }
    
    
    public func currentBookList() -> [BookModel]{
        
        
        let sql = "select Book_ID,imageURL,bookname from Book_BookList"
        let ret:FMResultSet = (db?.executeQuery(sql, withArgumentsIn: []))!
        var cacheArray:[BookModel] = Array.init()
        while ret.next() {
            let model = BookModel.init()
            model.bookID = ret.string(forColumn: "Book_ID")
            model.book_CoverIcon = BmobFile.init(filePath: "")
            model.book_CoverIcon?.url = ret.string(forColumn: "imageURL")
            model.book_name = ret.string(forColumn: "bookname")
            cacheArray.append(model)
            
        }
        
        return cacheArray
        
        
    }
    
    public func bookChapterCount(bookID:String) -> Int {
        
        let sql = "select ChapterCount from Book_BookList where Book_ID = ?"
        let ret = db?.executeQuery(sql, withArgumentsIn: [bookID])
        while (ret?.next())! {
            return Int.init((ret?.int(forColumn: "ChapterCount"))!)
        }
        
        return 0
    }
    public func saveBookChapter(chapterModel:BookChapterModel) -> Bool{
        let sql = "insert into Book_Chapter (Book_ID,indexs,name,content) values (?,?,?,?)"
        
        do{
            let ret = try?db!.executeUpdate(sql, withArgumentsIn: [chapterModel.Book_ID!,chapterModel.index!,chapterModel.chapterName!,chapterModel.content!])
            return ret!
        }catch let err as NSError{
            return false
        }
        return false
    }
}





























