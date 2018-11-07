//
//  BPArticleDetailVC.swift
//  BenefitPet
//  文章详情
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class BPArticleDetailVC: GYZBaseVC {
    
    var articleTitle: String = ""
    var url: String = ""
    var articleId: String = ""
    
    var huanZheId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = articleTitle
        self.view.backgroundColor = kWhiteColor
        
        if huanZheId != "" {
            let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight))
            rightBtn.setTitle("发送", for: .normal)
            rightBtn.setTitleColor(kBlackFontColor, for: .normal)
            rightBtn.titleLabel?.font = k14Font
            rightBtn.addTarget(self, action: #selector(onClickedSendBtn), for: .touchUpInside)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        loadContent()
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
    func loadContent(){
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
    }
    /// 发送
    @objc func onClickedSendBtn(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要发送给患者吗？", cancleTitle: "取消", viewController: self, buttonTitles: "发送") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestSendData()
            }
        }
    }
    
    /// 发送
    func requestSendData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/send_user_tips", parameters: ["u_id": huanZheId,"tips_id": articleId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.backRefreshData()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 回传，刷新数据
    func backRefreshData(){
        /// 发布通知, 完成订单后，刷新待办
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSendMessageData), object: nil,userInfo:["url" : url])
    }
}
extension BPArticleDetailVC : WKNavigationDelegate{
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
