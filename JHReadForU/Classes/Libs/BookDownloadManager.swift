//
//  BookDownloadManager.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/24.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class BookDownloadManager: NSObject {

    static let manager = BookDownloadManager()
    var taskArray:[URLSessionDownloadTask]?
    var bookIDArray:[String]?
    var bookModelArray:[BookModel]?
    var currentLocation:Int?
    var willSaveString:String?
    var hasSaveChapterName:[String]?
    var beforeTextLength = 0
    func download(model:BookModel) -> Void {
        
        if bookIDArray == nil {
            bookIDArray = Array.init()
            taskArray = Array.init()
            bookModelArray = Array.init()
        }
        
        
        
        if (JHDataBaseManager.manager.isExistsBook(bookModel: model)) {
            //任务已存在
            
            JHWorningAlert().showWorningWithString(string: "本地已存在本书籍！")
            return
        }
        
        
        
        if (bookIDArray!.contains((model.book_file?.url)!)) {
            //任务已存在
            
            JHWorningAlert().showWorningWithString(string: "任务已存在!")
            return
        }
        
        
        
        
        
        
        weak var weakSelf = self
            //任务不存在
        bookIDArray?.append((model.book_file?.url)!)
        let configuration = URLSessionConfiguration.default
        let manager = AFURLSessionManager.init(sessionConfiguration: configuration)
        let url = URL.init(string: (model.book_file?.url)!)
        let request = URLRequest.init(url: url!)
        let downloadTask = manager.downloadTask(with: request , progress: { (progress) in
            let dispathc = DispatchQueue.main
            dispathc.async {
                print("0")
            }
            
            
            }, destination: { (r_url, response) -> URL in
                
                var documentDirectoryURL = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                documentDirectoryURL = documentDirectoryURL?.appendingPathComponent("Download")
                let ret = documentDirectoryURL?.isFileURL
                if (ret!) {
                    do{
                        try?(FileManager.default.createDirectory(at: documentDirectoryURL!, withIntermediateDirectories: false, attributes: nil))
                    }
                    catch{
                        JHWorningAlert().showWorningWithString(string: "未知原因失败")
                       
                    }
                }

                return (documentDirectoryURL?.appendingPathComponent((model.book_file?.name!)!))!
                
                
                
            }) { (response, r_url, error) in
                
                JHWorningAlert().showSuccessWithString(string:"下载成功！")
                weakSelf?.parseBookFile(model: model)
        }
        downloadTask.resume()
        taskArray?.append(downloadTask)
        bookModelArray?.append(model)
    }
    
    
    
    func saveAllText(textString:NSString,model:BookModel) -> Void {
        var TitleArray:[String] = []
        let mutableSet = NSMutableSet.init()
        var lastTitleString = ""
        //前言内容

        var cuttentIndex = 0
        let condiction = "第[\\d一二三四五六七八九十百千万]*[章回节集篇](:?|：?)\\s.*(\\s|\\n)"
        do{
            let reg = try?NSRegularExpression.init(pattern: condiction, options: .caseInsensitive)
            reg!.enumerateMatches(in: textString as String, options: .reportCompletion, range: NSRange.init(location: 0, length: NSString.init(string: textString).length), using: { (result, flags, stop) in
                if result != nil{
                    let cacheStr = textString.substring(with: (result?.range)!)
                    if TitleArray.contains(cacheStr){
                        
                    }else{
                        mutableSet.add(result)
                        TitleArray.append(cacheStr)
                    }
                }
            })
            
            //合并后无章节时
            if mutableSet.count == 0 {
                    let bookChapter = BookChapterModel()
                    bookChapter.Book_ID = model.bookID
                    bookChapter.chapterName = lastTitleString
                    bookChapter.content = textString as String
                    bookChapter.index = model.saveIndex
                    if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                            model.saveIndex += 1
                            hasSaveChapterName?.append(lastTitleString)
                    }else{
                            //                            continue
                    }
                
            }else{
                
                let arr = mutableSet.sorted(by: { (current, next) -> Bool in
                    let cuttentR = current as! NSTextCheckingResult
                    let nextR = next as! NSTextCheckingResult
                    if cuttentR.range.location < nextR.range.location{
                        return true
                    }
                    return false
                })
                
                
                //遍历每次查询的结果
                for elementIndex in 0..<arr.count{
                    
                    let result = arr[elementIndex] as! NSTextCheckingResult
                    let titleS = textString.substring(with: result.range)
                    //每次结果的第一个元素
                    if elementIndex == 0 {
                            //并且查询结果的位置不为零 即存在前言
                            if  result.range.location != 0 {
                                //保存前言
                                lastTitleString = "前言"
                                let bookChapter = BookChapterModel()
                                bookChapter.Book_ID = model.bookID
                                bookChapter.chapterName = lastTitleString
                                bookChapter.content = textString.substring(with: NSRange.init(location: 0, length: result.range.location))
                                bookChapter.index = model.saveIndex
                                cuttentIndex = result.range.location
                                if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                    model.saveIndex += 1
                                }else{
                                        continue
                               }
                            }
                        }

                    if elementIndex != 0 && elementIndex < arr.count-1{
                        
                        let bookChapter = BookChapterModel()
                        bookChapter.Book_ID = model.bookID
                        bookChapter.chapterName = lastTitleString
                        bookChapter.content = textString.substring(with: NSRange.init(location: cuttentIndex, length: result.range.location - cuttentIndex))
                        bookChapter.index = model.saveIndex

                        if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                model.saveIndex += 1
                                hasSaveChapterName?.append(lastTitleString)
                                lastTitleString = titleS
                        }else{
                                continue
                        }

                    }
                    
                    
                    
                    if elementIndex == arr.count-1 {
                        let bookChapter = BookChapterModel()
                        bookChapter.Book_ID = model.bookID
                        bookChapter.chapterName = lastTitleString
                        bookChapter.content = textString.substring(with: NSRange.init(location: cuttentIndex, length: result.range.location - cuttentIndex))
                        bookChapter.index = model.saveIndex
                        print("now" + "\(bookChapter.index)")
                        
                        if (hasSaveChapterName?.contains(lastTitleString))! {
                            
                        }else{
                            print(bookChapter.chapterName)
                            
                            if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                model.saveIndex += 1
                                hasSaveChapterName?.append(lastTitleString)
                            }else{
                                continue
                            }
                        }

                        lastTitleString = titleS
                        bookChapter.Book_ID = model.bookID
                        bookChapter.chapterName = lastTitleString
                        bookChapter.content = textString.substring(from: result.range.location)
                        bookChapter.index = model.saveIndex

                                
                        if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
//                                    model.saveIndex += 1
                                    model.book_ChapterCount = model.saveIndex + 1
                                    hasSaveChapterName?.append(lastTitleString)
                        }else{
                                    continue
                        }
                    }


                    cuttentIndex = result.range.location
                    lastTitleString = titleS
                }
                
            }
            mutableSet.removeAllObjects()
        }catch let err as NSError{
            JHWorningAlert().showWorningWithString(string:"解析错误")
        }

        
        
    }
    
    
    func parseBookFile(model:BookModel) -> Void {
        currentLocation = 0
        willSaveString = ""
        hasSaveChapterName = Array.init()
        var documentDirectoryURL = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        documentDirectoryURL = documentDirectoryURL?.appendingPathComponent("Download/\((model.book_file?.name)!)")
        

        let textString = try? NSString.init(contentsOf: documentDirectoryURL!, encoding: String.Encoding.utf8.rawValue)
        
        if textString == nil {
            JHWorningAlert().showWorningWithString(string: "未知原因失败")
            return
        }
        
        saveAllText(textString: textString!,model: model)
        
        if JHDataBaseManager.manager.saveBook(bookModel: model){
            NotificationCenter.default.post(name: NSNotification.Name.init(JHBookListViewReloadDataSource), object: nil)
        }else{
             JHWorningAlert().showWorningWithString(string: "加入书架失败")
        }
        
        
        
        //由此打断 下面是另外一种文本解析方法 有bug
        return
            
        print(NSHomeDirectory())
        var fileHandle:FileHandle?
        do{
            let res = try?FileHandle.init(forReadingFrom: documentDirectoryURL!)
            if res == nil {
                throw NSError.init()
            }
            fileHandle = res
        } catch {
            JHWorningAlert().showWorningWithString(string:"解析错误")
        }
        
        fileHandle?.seekToEndOfFile()
        
        let fileLength = fileHandle?.offsetInFile
        fileHandle?.seek(toFileOffset: 0)
        
        
        
        
        
        
        
        
        //默认分片大小
        let defaultBytesSize = UInt64(102400)

        var index = 0
        var indexOfChapter = 0
        //循环获取分片 并存储缓存文件
        while (fileHandle?.offsetInFile)!<fileLength! {
            
            //筛选章节
            let txt = siftBytesOffSet(fileHandle: fileHandle!, defaultBytesSize: defaultBytesSize,maxOffSet: fileLength!)
            //存储章节
            saveCacheChapter(txt: txt, name: "\((model.book_name)!)\(index)")
            index += 1
            
        }
        

        for i in 0...index-1{
            let curretnTxt = getTxtFromName(urlString: "\((model.book_name)!)\(i)")
            var nextTxt:String?
            if i<index-1 {
                nextTxt = getTxtFromName(urlString: "\((model.book_name)!)\(i+1)")
            }else{
                nextTxt = ""
            }
            let resultSS = NSString.init(string: curretnTxt + nextTxt!)
            print("第\(i)分区")
            saveChapterInfo(resultSS: resultSS,model: model, i:i,index: index-1,nextString: nextTxt!,currentString: curretnTxt,saveIndex: indexOfChapter)
        }
    }
    
    
    
    //保存章节信息 resultSS：合并的章节结果字符串 model：当前的书籍信息 i：当前的第几部分 index：总共的部分个数
    func saveChapterInfo(resultSS:NSString , model:BookModel,i:Int,index:Int,nextString:String,currentString:String,saveIndex:Int) -> Void {
        let currentLength = NSString.init(string: currentString).length
        let nextLength = NSString.init(string: nextString).length
        let mutableSet = NSMutableSet.init()
        var TitleArray:[String] = Array.init()
        var locationIndex = 0
        var lastString = ""
        var lastTitleString = ""
        //前言内容
        var titleContent:String?
        var nowIndex = 0
        var subStringBeginLocation:Int = 0
        let condiction = "第[\\d一二三四五六七八九十百千万]*[章回节]\\s.*(\\s|\\n)"
        do{
            let reg = try?NSRegularExpression.init(pattern: condiction, options: .caseInsensitive)
            var enumerIndex = 0
            reg!.enumerateMatches(in: resultSS as String, options: .reportCompletion, range: NSRange.init(location: 0, length: resultSS.length), using: { (result, flags, stop) in
                if result != nil{
                    if enumerIndex==0{
                        if result?.range.location != 0{
                            titleContent = resultSS.substring(with: NSRange.init(location: 0, length: (result?.range.location)!))
                        }
                    }
                    let cacheStr = resultSS.substring(with: result!.range)
                    if TitleArray.contains(cacheStr){
                        
                    }else{
                        mutableSet.add(result)
                        TitleArray.append(cacheStr)
                    }
                }
            })
            
            //合并后无章节时
            if mutableSet.count == 0 {
                willSaveString = willSaveString! + nextString
                
                if i == index - 1{
                    let bookChapter = BookChapterModel()
                    bookChapter.Book_ID = model.bookID
                    bookChapter.chapterName = lastTitleString
                    bookChapter.content = willSaveString
                    bookChapter.index = model.saveIndex

                    if (hasSaveChapterName?.contains(lastTitleString))! {

                    }else{
                        print(bookChapter.chapterName)

                        if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                            model.saveIndex += 1
                            hasSaveChapterName?.append(lastTitleString)
                        }else{
//                            continue
                        }
                    }
                }

            }else{
                
                let arr = mutableSet.sorted(by: { (current, next) -> Bool in
                    let cuttentR = current as! NSTextCheckingResult
                    let nextR = next as! NSTextCheckingResult
                    if cuttentR.range.location < nextR.range.location{
                        return true
                    }
                    return false
                })

                
                //遍历每次查询的结果
                for elementIndex in 0..<arr.count{
                    
                    let result = arr[elementIndex] as! NSTextCheckingResult
                    let titleS = resultSS.substring(with: result.range)
                    //每次结果的第一个元素
                    if elementIndex == 0 {
                        subStringBeginLocation = 0
                        willSaveString = willSaveString! + resultSS.substring(with: NSRange.init(location: subStringBeginLocation, length: result.range.location - subStringBeginLocation))
                        if currentLocation == 0 {
                            
                            //并且查询结果的位置不为零 即存在前言
                            if  result.range.location != 0 {
                                //保存前言
                                lastTitleString = "前言"
                                let bookChapter = BookChapterModel()
                                bookChapter.Book_ID = model.bookID
                                bookChapter.chapterName = lastTitleString
                                bookChapter.content = willSaveString
                                bookChapter.index = model.saveIndex
                                
                                if (hasSaveChapterName?.contains(lastTitleString))! {
//                                    continue
                                }else{
                                    print(bookChapter.chapterName)

                                    if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                        model.saveIndex += 1
                                        hasSaveChapterName?.append(lastTitleString)
                                    
                                    }else{
                                        continue
                                    }
                                }
                            }
                            
                            lastString = ""
                            lastTitleString = titleS
                            subStringBeginLocation = result.range.location
                        }else{//不是第一分片的第一个元素
                            
                            
                            subStringBeginLocation = result.range.location - beforeTextLength
                            let bookChapter = BookChapterModel()
                            bookChapter.Book_ID = model.bookID
                            bookChapter.chapterName = lastTitleString
                            bookChapter.content = willSaveString
                            bookChapter.index = model.saveIndex
                            if (hasSaveChapterName?.contains(lastTitleString))! {
//                                continue
                            }else{
                                print(bookChapter.chapterName)

                                if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                    model.saveIndex += 1
                                    hasSaveChapterName?.append(lastTitleString)
                                    lastTitleString = titleS
                                }else{
                                    continue
                                }
                            }
                        }
                        
                    }
                    
                    willSaveString = resultSS.substring(with: NSRange.init(location: subStringBeginLocation, length: result.range.location - subStringBeginLocation))
                    
                    if elementIndex != 0 && elementIndex < arr.count-1{
                        
                        let bookChapter = BookChapterModel()
                        bookChapter.Book_ID = model.bookID
                        bookChapter.chapterName = lastTitleString
                        bookChapter.content = willSaveString
                        bookChapter.index = model.saveIndex
                        subStringBeginLocation = result.range.location
                        
                        print(titleS)
                        if (hasSaveChapterName?.contains(lastTitleString))! {

                        }else{
                            print(bookChapter.chapterName)

                            if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                model.saveIndex += 1
                                hasSaveChapterName?.append(lastTitleString)
                                lastTitleString = titleS
                            }else{
                                continue
                            }
                        }
                    }
                    
                    
                    
                    if elementIndex == arr.count-1 {
                        let bookChapter = BookChapterModel()
                        bookChapter.Book_ID = model.bookID
                        bookChapter.chapterName = lastTitleString
                        bookChapter.content = willSaveString
                        bookChapter.index = model.saveIndex
                        print("now" + "\(bookChapter.index)")
                        
                        if (hasSaveChapterName?.contains(lastTitleString))! {

                        }else{
                            print(bookChapter.chapterName)

                            if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                model.saveIndex += 1
                                hasSaveChapterName?.append(lastTitleString)
                            }else{
                                continue
                            }
                        }
                        
                        lastString = ""
                        locationIndex = result.range.location
                        lastTitleString = titleS
                        lastString = resultSS.substring(from: result.range.location)
                        willSaveString = lastString
                        subStringBeginLocation = result.range.location
                        if i == index - 1{
                            bookChapter.Book_ID = model.bookID
                            bookChapter.chapterName = lastTitleString
                            bookChapter.content = lastString
                            bookChapter.index = model.saveIndex
                            if (hasSaveChapterName?.contains(lastTitleString))! {
//                                continue
                            }else{
                                print(bookChapter.chapterName)

                                if JHDataBaseManager.manager.saveBookChapter(chapterModel: bookChapter){
                                    model.saveIndex += 1
                                    hasSaveChapterName?.append(lastTitleString)
                                }else{
                                    continue
                                }
                            }
                        }
                    }
                    
                    
                }
                
            }
            mutableSet.removeAllObjects()
        }catch let err as NSError{
            JHWorningAlert().showWorningWithString(string:"解析错误")
        }
        
        beforeTextLength = currentLength
        
    }
    
    

    func getTxtFromName(urlString:String) -> String {
        
        var documentDirectoryURL = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        documentDirectoryURL?.appendPathComponent("Cache/\(urlString)")
        do{
            let txt = try?String.init(contentsOf: documentDirectoryURL!)
            return txt!
        }catch let err as NSError{
             JHWorningAlert().showWorningWithString(string:"解析错误")
            return ""
        }

        
    }
    
    
    func saveCacheChapter(txt:String,name:String) -> Void {
        
        var documentDirectoryURL = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        documentDirectoryURL?.appendPathComponent("Cache")
        
        do{
             try?FileManager.default.createDirectory(at: documentDirectoryURL!, withIntermediateDirectories: false, attributes: nil)
        }catch let err as NSError{
            JHWorningAlert().showWorningWithString(string:"解析错误")
            return
        }
        
        documentDirectoryURL = documentDirectoryURL?.appendingPathComponent("\(name)")

        do{
            try? txt.write(to: documentDirectoryURL!, atomically: true, encoding: .utf8)
        }catch let err as NSError{
            JHWorningAlert().showWorningWithString(string:"解析错误")
            return
        }
        

        
        
    }
    
    
    
    func siftBytesOffSet(fileHandle:FileHandle,defaultBytesSize:UInt64,maxOffSet:UInt64) -> String {
        var defaultBytes:UInt64 = defaultBytesSize
        if fileHandle.offsetInFile + UInt64(defaultBytesSize) >= maxOffSet {
            defaultBytes = maxOffSet - fileHandle.offsetInFile
            let data = fileHandle.readData(ofLength: Int(defaultBytes))
            let str = String.init(data: data, encoding: .utf8)
            if str == nil {
                return ""
            }
            return str!
        }
        let data = fileHandle.readData(ofLength: Int(defaultBytes))
        let str = String.init(data: data, encoding: .utf8)
        if str == nil {
            fileHandle.seek(toFileOffset: fileHandle.offsetInFile - defaultBytes)
            return siftBytesOffSet(fileHandle: fileHandle,  defaultBytesSize: defaultBytesSize + 1,maxOffSet: maxOffSet)
        }else{
            return str!
        }
        
    }
    
    
   
    
}











































