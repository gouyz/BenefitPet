//
//  BPWenZhenTableDetailCell.swift
//  BenefitPet
//  问诊表详情 cell
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPWenZhenTableDetailCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(sortLab)
        contentView.addSubview(nameLab)
        contentView.addSubview(contentLab)
        
        sortLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(sortLab.snp.right).offset(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.right.equalTo(-kMargin)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(nameLab)
            make.width.equalTo(kScreenWidth * 0.5)
        }
    }
    
    /// 排序
    lazy var sortLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.backgroundColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "1"
        
        return lab
    }()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "您的宠物年龄?"
        
        return lab
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.borderColor = kBlackFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
