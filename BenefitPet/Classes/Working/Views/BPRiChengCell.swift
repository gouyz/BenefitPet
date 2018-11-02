//
//  BPRiChengCell.swift
//  BenefitPet
//  日程 cell
//  Created by gouyz on 2018/8/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPRiChengCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : BPRiChengModel?{
        didSet{
            if let model = dataModel {
                
                if model.date?.count == 10{
                    dateLab.text = (model.date?.subString(start: (model.date?.count)! - 2, length: 2))! + "日"
                }
                
                timeLab.text = model.time
                contentLab.text = model.richeng
                nameLab.text = (model.nickname?.isEmpty)! ? model.name : model.nickname
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(dateLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(lineView1)
        contentView.addSubview(circleView)
        contentView.addSubview(lineView2)
        contentView.addSubview(contentLab)
        contentView.addSubview(nameLab)
//        contentView.addSubview(rightIconView)
        
        dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.width.equalTo(dateLab)
            make.top.equalTo(dateLab.snp.bottom)
            make.height.equalTo(20)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.centerX.equalTo(circleView)
            make.width.equalTo(klineWidth)
            make.bottom.equalTo(circleView.snp.top)
        }
        circleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(dateLab.snp.right)
            make.size.equalTo(CGSize.init(width: 10, height: 10))
        }
        lineView2.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(lineView1)
            make.bottom.equalTo(contentView)
            make.top.equalTo(circleView.snp.bottom)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(nameLab.snp.left).offset(-5)
            make.left.equalTo(circleView.snp.right).offset(5)
        }
        nameLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(contentLab)
            make.width.equalTo(80)
        }
//        rightIconView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(contentView)
//            make.right.equalTo(-kMargin)
//            make.size.equalTo(CGSize.init(width: 7, height: 12))
//        }
    }
    /// date
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "06日"
        
        return lab
    }()
    /// time
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.text = "09:00"
        
        return lab
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()
    /// 圆
    var circleView : UIView = {
        let line = UIView()
        line.cornerRadius = kCornerRadius
        line.borderColor = kBlueFontColor
        line.borderWidth = klineWidth
        
        return line
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "门诊复查"
        
        return lab
    }()
    /// 名称
    var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "欢欢"
        
        return lab
    }()
    /// 右侧箭头图标
//    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
}
