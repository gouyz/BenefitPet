//
//  BPCashRecordManagerVC.swift
//  BenefitPet
//  提现记录
//  Created by gouyz on 2018/8/15.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPCashRecordManagerVC: GYZBaseVC {

    let titleArr : [String] = ["全部","待打款","已打款","已拒绝"]
    
    //订单状态1待受理2已受理3已发货4已取消5已完成
    let stateValue : [String] = ["-1","1","2","3"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "提现记录"
        
        setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [BPCashRecordVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = BPCashRecordVC()
            vc.status = stateValue[index]
            childVC.append(vc)
        }
        
        return childVC
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
