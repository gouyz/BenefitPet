//
//  BPChatManagerVC.swift
//  BenefitPet
//  患者聊天、同步诊疗记录
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPChatManagerVC: GYZBaseVC {
    
    var conversation: JMSGConversation?
    
    let titleArr : [String] = ["患者聊天","同步诊疗记录"]

    var scrollPageView: ScrollPageView?
    /// 当前索引
    var currIndex: Int = 0
    var huanZheId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = conversation?.target as? JMSGUser
        self.navigationItem.title = user?.displayName() ?? ""
        let uId: String = (user?.username)!
        /// 根据极光id获取患者id  yichongc、yichongd
        huanZheId = uId.subString(start: 8, length: uId.count - 8)
        setScrollView()
        
        if currIndex > 0 {
            scrollPageView?.selectedIndex(currIndex, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        let chatVC = BPChatMessageVC()
        chatVC.conversation = conversation
        chatVC.huanZheId = huanZheId
        
        let recordVC = BPZhenLiaoRecordVC()
        recordVC.huanZheId = huanZheId
        
        return [chatVC,recordVC]
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kBlueFontColor
        style.normalTitleColor = kBlackFontColor
        style.selectedTitleColor = kBlueFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: CGRect.init(x: 0, y: kTitleAndStateHeight, width: kScreenWidth, height: self.view.frame.height - kTitleAndStateHeight), segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }
}
