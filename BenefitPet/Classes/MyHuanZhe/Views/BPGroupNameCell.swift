//
//  BPGroupNameCell.swift
//  BenefitPet
//  分组名称 cell
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPGroupNameCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(nameTxtFiled)
        
        nameTxtFiled.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(self)
        }
    }
    
    /// 名称输入框
    lazy var nameTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入分组名称 如：门诊"
        
        return textFiled
    }()
    
}
