//
//  BPFollowPlanDetailVC.swift
//  BenefitPet
//  随访计划详情
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import WebKit


class BPFollowPlanDetailVC: GYZBaseVC {
    
    var planTitle: String = ""
    var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = planTitle
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        loadContent(content: url)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.navigationDelegate = self
        
        return webView
    }()
    
    
    /// 加载
    func loadContent(content: String){
        if content.hasPrefix("http://") || content.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: content)!))
        }else{
            webView.loadHTMLString(content.dealFuTextImgSize().htmlToString, baseURL: nil)
        }
    }
}
extension BPFollowPlanDetailVC : WKNavigationDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        createHUD(message: "加载中...")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        self.hud?.hide(animated: true)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.hud?.hide(animated: true)
    }
}
