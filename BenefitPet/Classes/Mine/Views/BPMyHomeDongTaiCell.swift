//
//  BPMyHomeDongTaiCell.swift
//  BenefitPet
//  我的动态cell
//  Created by gouyz on 2018/8/14.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPMyHomeDongTaiCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kBackgroundColor
        
        contentView.addSubview(bgView)
        bgView.backgroundColor = kWhiteColor
        bgView.addSubview(contentLab)
        bgView.addSubview(imgViews)
        bgView.addSubview(userHeaderView)
        bgView.addSubview(nameLab)
        bgView.addSubview(timeLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(-klineWidth)
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userHeaderView.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userHeaderView)
            make.height.equalTo(20)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.left.right.equalTo(contentLab)
            make.height.equalTo(0)
        }
        
        timeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLab)
            make.top.equalTo(imgViews.snp.bottom)
            make.height.equalTo(30)
            make.bottom.equalTo(bgView)
        }
    }
    
    lazy var bgView : UIView = UIView()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_default"))
        imgView.cornerRadius = 15
        
        return imgView
    }()
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "玛丽"
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "聊聊什么是让孩子受益终身的行为习惯，聊聊什么是让孩子受益终身的行为习惯，聊聊什么是让孩子受益终身的行为习惯"
        
        return lab
    }()
    
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "2小时前"
        
        return lab
    }()
}
