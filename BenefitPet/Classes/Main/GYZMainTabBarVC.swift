//
//  GYZMainTabBarVC.swift
//  baking
//  底部导航控制器
//  Created by gouyz on 2017/3/23.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZMainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp(){
        tabBar.tintColor = kBlueFontColor
        /// 解决iOS12.1 子页面返回时底部tabbar出现了错位
        tabBar.isTranslucent = false
        
        addViewController(BPWorkingVC(), title: "工作站", normalImgName: "icon_tabbar_working")
        addViewController(BPUnicomVC(), title: "益联通", normalImgName: "icon_tabbar_unicom")
        addViewController(BPMyHuanZheVC(), title: "我的患者", normalImgName: "icon_tabbar_huanzhe")
        addViewController(BPSchoolVC(), title: "兽医学院", normalImgName: "icon_tabbar_school")
        addViewController(BPMineVC(), title: "个人中心", normalImgName: "icon_tabbar_mine")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 添加子控件
    fileprivate func addViewController(_ childController: UIViewController, title: String,normalImgName: String) {
        let nav = GYZBaseNavigationVC.init(rootViewController: childController)
        addChildViewController(nav)
        childController.tabBarItem.title = title
//        childController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
        childController.tabBarItem.image = UIImage(named: normalImgName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: normalImgName + "_selected")?.withRenderingMode(.alwaysOriginal)
    }
}

