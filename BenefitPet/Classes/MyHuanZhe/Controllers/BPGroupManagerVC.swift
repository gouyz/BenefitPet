//
//  BPGroupManagerVC.swift
//  BenefitPet
//  分组管理
//  Created by gouyz on 2018/8/17.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPGroupManagerVC: GYZBaseVC {
    
    var groupArr: [String] = ["门诊","住院","内科","骨科","门诊","住院","内科","骨科"]
    /// 分类高度
    var groupHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "分组管理"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        groupHeight = HXTagsView.getHeightWithTags(groupArr, layout: allGroupTagsView.layout, tagAttribute: allGroupTagsView.tagAttribute, width: kScreenWidth)
        
        allGroupTagsView.snp.updateConstraints { (make) in
            make.height.equalTo(groupHeight)
        }
        allGroupTagsView.tags = groupArr
        
        selectedTagsView.tags = ["门诊"]
        selectedTagsView.selectedTags = ["门诊"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(selectedTagsView)
        view.addSubview(marginView)
        view.addSubview(desLab)
        view.addSubview(allGroupTagsView)
        
        selectedTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(60)
        }
        
        marginView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(selectedTagsView.snp.bottom)
            make.height.equalTo(kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(marginView.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        
        allGroupTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(0)
        }
    }
    

    /// 选择分组
    lazy var selectedTagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        view.tagAttribute.cornerRadius = kCornerRadius
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    lazy var marginView: UIView = {
        
        let line = UIView()
        line.backgroundColor = kBackgroundColor
        
        return line
    }()
    /// 所有分组
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "所有分组"
        
        return lab
    }()
    /// 所有分组
    lazy var allGroupTagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        view.tagAttribute.cornerRadius = kCornerRadius
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    /// 保存
    @objc func onClickRightBtn(){
        
    }
}
