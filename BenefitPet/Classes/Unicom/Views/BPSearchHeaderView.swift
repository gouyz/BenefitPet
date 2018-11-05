//
//  BPSearchHeaderView.swift
//  BenefitPet
//  搜索
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSearchHeaderView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        
        addSubview(searchBtn)
        
        searchBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.right.equalTo(-20)
        }
        
        searchBtn.set(image: UIImage.init(named: "icon_search"), title: "搜索好友", titlePosition: .right, additionalSpacing: 5, state: .normal)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 搜索
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.backgroundColor = kWhiteColor
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
}
