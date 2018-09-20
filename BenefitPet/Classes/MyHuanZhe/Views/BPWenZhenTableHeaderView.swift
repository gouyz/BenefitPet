//
//  BPWenZhenTableHeaderView.swift
//  BenefitPet
//  问诊表 header
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPWenZhenTableHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(leftView)
        contentView.addSubview(nameLab)
        
        leftView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        
        return view
    }()
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "全科问诊表"
        
        return lab
    }()
}
