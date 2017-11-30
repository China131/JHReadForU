//
//  JHWebViewVC.swift
//  JHReadForU
//
//  Created by 简豪 on 2016/11/15.
//  Copyright © 2016年 codingMan. All rights reserved.
//

import UIKit

class JHWebViewVC: JHBaseViewController {

    var webView: UIWebView?
    var url:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView.init(frame: CGRect.init())
        self.view.addSubview(webView!)
        self.setTitleWithString(title: "")
        weak var weakSelf = self
        _ = webView?.mas_makeConstraints({ (make) in
            _ = make?.left.equalTo()(weakSelf?.view.mas_left)
            _ = make?.right.equalTo()(weakSelf?.view.mas_right)
            _ = make?.bottom.equalTo()(weakSelf?.view.mas_bottom)
            _ = make?.top.equalTo()(weakSelf?.view.mas_top)?.offset()(64)
        })
        
        webView!.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
        // Do any additional setup after loading the view.
    }

    override func baseBackClick() {
        if (webView?.canGoBack)! {
            webView?.goBack()
            return
        }
        
        super.baseBackClick()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        print(webView)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
