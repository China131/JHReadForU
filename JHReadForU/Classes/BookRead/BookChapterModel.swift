//
//  BookChapterModel.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/25.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class BookChapterModel: NSObject {
    var chapterName:String?
    var content:String?
    var ID:String?
    var Book_ID:String?
    var index:Int?
}









class BookReadRecoder: NSObject{
    var bookName:String?{
       
        didSet{
            var cacheRecord:[String:Any]? = UserDefaults.standard.value(forKey: "ReadingRecord") as! [String : Any]?
            if cacheRecord == nil{
                currentLocation = 0
                self.chapterIndex = 0
                self.currentLength = 0
                return
            }
            
            let currentRecord = cacheRecord![bookName!]
            if currentRecord == nil{
                currentLocation = 0
                self.chapterIndex = 0
                self.currentLength = 0
                return
            }
            
            currentLocation = cacheRecord!["CurrentLocation"] as? Int
            chapterIndex = cacheRecord!["ChapterIndex"] as? Int
            
            
        }
    }
    var readPandelFontSize:CGFloat?
    var readPandelBackgroundColor:UIColor?
    var readPandelForegroundColor:UIColor?
    var bookID:String?{
        didSet{
            currentBookChapterCount = JHDataBaseManager.manager.bookChapterCount(bookID: bookID!)
        }
    }
    
    var chapterIndex:Int?
    var currentLocation:Int?
    var currentContent:String?
    var currentChapterContent:NSString?
    var currentLength:Int?
    var currentBookChapterCount:Int?
    static let defaultRecord:BookReadRecoder = BookReadRecoder.init()
    override init(){
        super.init()
        var readSetting:[String:Any]? = UserDefaults.standard.value(forKey: "ReadSetting") as! [String : Any]?
        if readSetting == nil{
            self.readPandelFontSize = CGFloat(14)
            self.readPandelBackgroundColor = UIColor.lightGray
            self.readPandelForegroundColor = UIColor.darkText
            readSetting = Dictionary.init()
            readSetting?.updateValue(self.readPandelFontSize!, forKey: "ReadFontSize")
//            readSetting?.updateValue(self.readPandelForegroundColor!, forKey: "ReadPandelForegroundColor")
//            readSetting?.updateValue(self.readPandelBackgroundColor!, forKey: "ReadPandelBackgroundColor")
            UserDefaults.standard.set(readSetting, forKey: "ReadSetting")
            UserDefaults.standard.synchronize()
        }else{
            
            self.readPandelFontSize = readSetting!["ReadFontSize"] as! CGFloat
//            self.readPandelForegroundColor = readSetting!["ReadPandelForegroundColor"] as! UIColor
//            self.readPandelBackgroundColor = readSetting!["ReadPandelBackgroundColor"] as! UIColor
            
        }
        
        
        
    }
    
    
    func cacheCurrentContent() -> Void {
        
        self.currentChapterContent = JHDataBaseManager.manager.findChapter(chapterIndex: self.chapterIndex!, bookID: self.bookID!)
        
    }
    
    
    
    func beforeLength() -> Int {
        
        return 1
        
    }
    
    
    
    func nextLength() -> Int {
        var length = 600
        var up:Bool?
        var first = true
        if (self.currentChapterContent?.length)! - currentLength! - currentLocation! <= 600 {
            length = (self.currentChapterContent?.length)! - currentLength! - currentLocation!
            
            currentLocation = self.currentChapterContent?.length
            
            return length
        }
        
        while true {
            
            let subString:NSString = NSString.init(string: (self.currentChapterContent?.substring(with: NSRange.init(location: self.currentLocation! + currentLength!, length: length)))!)
            let height = subString.boundingRect(with: CGSize.init(width: UISCREEN_WIDTH - 20, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.readPandelFontSize!)], context: nil).size.height
            
            
            if first {
                if height > UISCREEN_HEIGHT - 60 {
                    up = false
                }else{
                    up = true
                }
                first = false
            }

            
            //大于文本框高度 并且是上升状态
            if height > UISCREEN_HEIGHT - 60 && up!{
                return length - 1
                
            //小于文本框高度 并且是下降状态
            }else if height <= UISCREEN_HEIGHT - 60 && !up!{
                
                return length
            }else{
                
                if up! {
                    //上升状态 字符不够时
                    if height < UISCREEN_HEIGHT - 60 {
                        length = length + 1
                    }
                    
                }else{
                    //下降状态 字符多余时
                    if height > UISCREEN_HEIGHT - 60 {
                        length = length - 1
                    }
                }
                
            }
            
        }
        return length
        
    }
    
    
    static func NextString()->String{
        
        if BookReadRecoder.defaultRecord.currentContent == nil{
            BookReadRecoder.defaultRecord.cacheCurrentContent()
        }
        
        
        print(BookReadRecoder.defaultRecord.nextLength())
        
        
        return ""
        
    }
    
    static func BeforeString()->String{
        if BookReadRecoder.defaultRecord.currentContent == nil{
            BookReadRecoder.defaultRecord.cacheCurrentContent()
        }
        
        return ""
    }
    
    
    
    
    func saveReadingRecord() -> Void {
        var defaultRecordDic:[String:Any]? = UserDefaults.value(forKey: "ReadingRecord") as! [String : Any]?
        if defaultRecordDic == nil{
            defaultRecordDic = Dictionary.init()
        }
        
        var willSaveDic:[String:Any] = Dictionary.init()
        
        willSaveDic.updateValue(BookReadRecoder.defaultRecord.chapterIndex, forKey: "ChapterIndex")
        willSaveDic.updateValue(BookReadRecoder.defaultRecord.currentLocation, forKey: "CurrentLocation")
        UserDefaults.standard.set(defaultRecordDic, forKey: "ReadingRecord")
        UserDefaults.standard.synchronize()
        
        
        
    }
    
    

}
