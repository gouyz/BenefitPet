//
//  BPSelectHuanZheHeaderView.swift
//  BenefitPet
//  分组选择患者 header
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSelectHuanZheHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(allCheckView)
        contentView.addSubview(rightBtn)
        
        allCheckView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(kScreenWidth * 0.5)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(30)
        }
    }
    
    /// 全选
    lazy var allCheckView: LHSCheckView = {
        let checkView = LHSCheckView()
        checkView.tagImgView.image = UIImage.init(named: "icon_check_circle")
        checkView.nameLab.text = "收藏患者|5"
        
        return checkView
    }()
    /// 右侧箭头展示
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage.init(named: "icon_up_arrow"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_down_arrow"), for: .selected)
        
        return btn
    }()
}
