//
//  BPWorkingCell.swift
//  BenefitPet
//  工作站cell
//  Created by gouyz on 2018/7/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPWorkingCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.backgroundColor = kWhiteColor
        
        bgView.addSubview(categoryLab)
        bgView.addSubview(lineView)
        bgView.addSubview(contentLab)
        bgView.addSubview(contentImgView)
        bgView.addSubview(desLab)
        
        bgView.addSubview(sourceLab)
        bgView.addSubview(timeLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(-kMargin)
        }
        categoryLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(30)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(categoryLab.snp.right)
            make.centerY.equalTo(categoryLab)
            make.height.equalTo(klineWidth)
            make.right.equalTo(bgView)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(categoryLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(categoryLab.snp.bottom).offset(5)
        }
        contentImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLab)
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.24)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentImgView.snp.bottom).offset(5)
            make.left.right.equalTo(contentLab)
        }
        sourceLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentLab)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.right.equalTo(timeLab.snp.left).offset(-kMargin)
            make.height.equalTo(24)
            make.bottom.equalTo(-kMargin)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(contentLab)
            make.top.height.bottom.equalTo(sourceLab)
            make.width.equalTo(100)
        }
        
    }
    
    lazy var bgView : UIView = UIView()
    
    /// 类别
    lazy var categoryLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlueFontColor
        lab.font = k13Font
        lab.text = "宠物喂养》"
        
        return lab
    }()
    
    ///
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "生态粮生态粮生态粮生态粮生态粮生态粮生态粮生态粮生态粮生态粮生态粮"
        
        return lab
    }()
    
    /// 图片
    lazy var contentImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_working_default")
        imgView.cornerRadius = kCornerRadius
        
        return imgView
    }()
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        lab.text = "生态粮中富含的蛋白质、维生素以及多种微量元素，生态粮中富含的蛋白质、维生素以及多种微量元素，生态粮中富含的蛋白质、维生素以及多种微量元素"
        
        return lab
    }()
    
    /// 来源
    lazy var sourceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "来源：益宠报刊"
        
        return lab
    }()
    
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.textAlignment = .right
        lab.text = "今天15：00"
        
        return lab
    }()
}
