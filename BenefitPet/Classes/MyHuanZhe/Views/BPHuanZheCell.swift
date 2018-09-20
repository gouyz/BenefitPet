//
//  BPHuanZheCell.swift
//  BenefitPet
//  我的患者cell
//  Created by gouyz on 2018/8/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPHuanZheCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(noteLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(lineView)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(noteLab.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        noteLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(100)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(iconView)
            make.left.right.equalTo(nameLab)
        }
        dateLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentLab)
            make.right.width.equalTo(noteLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.cornerRadius = 20
        imgView.image = UIImage.init(named: "icon_header_default")
        
        return imgView
    }()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "欢欢"
        
        return lab
    }()
    
    /// 备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "(备注：消化不良)"
        
        return lab
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "你好"
        
        return lab
    }()
    /// 日期
    var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "08月06日 15：40"
        
        return lab
    }()
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
