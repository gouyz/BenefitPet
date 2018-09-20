//
//  BPZhenLiaoRecordInfoCell.swift
//  BenefitPet
//  诊疗记录患者信息cell
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPZhenLiaoRecordInfoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(userImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView)
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.bottom.equalTo(lineView.snp.top)
        }
        userImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-5)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 用户头像
    lazy var userImgView : UIImageView = {
        let img = UIImageView()
        img.cornerRadius = 25
        img.borderColor = kWhiteColor
        img.borderWidth = klineDoubleWidth
        img.image = UIImage.init(named: "icon_header_default")
        
        return img
    }()
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "欢欢"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
