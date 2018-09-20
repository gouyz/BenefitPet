//
//  BPOnLineOrderVC.swift
//  BenefitPet
//  在线接单
//  Created by gouyz on 2018/8/1.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPOnLineOrderVC: GYZBaseVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "在线接单"
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        view.addSubview(iconView)
        view.addSubview(onLineBtn)
        view.addSubview(lineView)
        view.addSubview(noteLab)
        view.addSubview(contentLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(kScreenWidth * 0.3)
        }
        onLineBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(iconView.snp.bottom).offset(kTitleHeight)
            make.width.equalTo(200)
            make.height.equalTo(kUIButtonHeight)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(onLineBtn.snp.bottom).offset(50)
            make.left.right.equalTo(view)
            make.height.equalTo(kMargin)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(noteLab)
            make.top.equalTo(noteLab.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_working_online"))
    
    /// 在线接单
    lazy var onLineBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnNoClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitleColor(kWhiteColor, for: .selected)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("立即接单", for: .normal)
        btn.setTitle("正在接单", for: .selected)
        btn.addTarget(self, action: #selector(clickedOnLineBtn), for: .touchUpInside)
        return btn
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "说明："
        
        return lab
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.textColor = kHeightGaryFontColor
        lab.text = "1、在线接单时间为10:00~18:00\n2、在线接单时间为10:00~18:00"
        
        return lab
    }()
    ///立即接单
    @objc func clickedOnLineBtn(){
        onLineBtn.isSelected = !onLineBtn.isSelected
        if onLineBtn.isSelected {
            onLineBtn.backgroundColor = kBtnClickBGColor
        }else{
            onLineBtn.backgroundColor = kBtnNoClickBGColor
        }
    }
}
