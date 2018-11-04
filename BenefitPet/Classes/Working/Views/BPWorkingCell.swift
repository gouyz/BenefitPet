//
//  BPWorkingCell.swift
//  BenefitPet
//  工作站cell
//  Created by gouyz on 2018/7/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPWorkingCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : BPHomeNewModel?{
        didSet{
            if let model = dataModel {
                
                categoryLab.text = model.title! + "》"
                
//                let attrStr = try! NSMutableAttributedString.init(data: (model.content?.dealFuTextImgSize().htmlToString.data(using: .unicode, allowLossyConversion: true))!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//                //调整行间距
//                let paragraphStye = NSMutableParagraphStyle()
//
//                paragraphStye.lineSpacing = 5
//                let rang = NSMakeRange(0, attrStr.length)
//                attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: rang)
                
//                contentLab.attributedText = attrStr
                contentLab.text = model.abstract
                contentImgView.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.init(named: "icon_working_default"), options: nil, progressBlock: nil, completionHandler: nil)
                
                timeLab.text = model.add_time?.dateFromTimeInterval()?.dateDesc
            }
        }
    }

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
//        bgView.addSubview(desLab)
        
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
            make.top.equalTo(categoryLab.snp.bottom).offset(kMargin)
        }
        contentImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLab)
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.24)
        }
//        desLab.snp.makeConstraints { (make) in
//            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
//            make.left.right.equalTo(contentLab)
//        }
        sourceLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentLab)
            make.top.equalTo(contentImgView.snp.bottom).offset(kMargin)
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
        
        return lab
    }()
    
    /// 图片
    lazy var contentImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = kCornerRadius

        return imgView
    }()
    
    /// 描述
//    lazy var desLab : UILabel = {
//        let lab = UILabel()
//        lab.textColor = kBlackFontColor
//        lab.font = k13Font
//        lab.numberOfLines = 0
//
//        return lab
//    }()
    
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
        
        return lab
    }()
}
