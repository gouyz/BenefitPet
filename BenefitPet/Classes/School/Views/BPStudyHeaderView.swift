//
//  BPStudyHeaderView.swift
//  BenefitPet
//  学习园地header
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPStudyHeaderView: UITableViewHeaderFooterView {

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
        contentView.addSubview(desLab)
        contentView.addSubview(rightIconView)
        
        leftView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(desLab.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(contentView)
        }
        desLab.snp.makeConstraints { (make) in
            make.right.equalTo(rightIconView.snp.left)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(40)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 13))
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
        
        return lab
    }()
    /// 
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "全部"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow_blue"))
}
