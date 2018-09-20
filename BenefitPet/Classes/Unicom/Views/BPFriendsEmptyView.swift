//
//  BPFriendsEmptyView.swift
//  BenefitPet
//  朋友空页面
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPFriendsEmptyView: UIView {
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        addSubview(operatorBtn)
        addSubview(desLab)
        
        operatorBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(kUIButtonHeight)
            make.width.equalTo(200)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(operatorBtn.snp.top).offset(-60)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "暂无数据"
        
        return lab
    }()
    
    /// 操作按钮
    lazy var operatorBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("立即完善", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
}
