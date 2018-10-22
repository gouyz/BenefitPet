//
//  BPSelectHuanZheCell.swift
//  BenefitPet
//  分组选择患者 cell
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSelectHuanZheCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : BPHuanZheModel?{
        didSet{
            if let model = dataModel {
                
                
                nameLab.text = model.nickname
                userImgView.kf.setImage(with: URL.init(string: (dataModel?.head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
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
        contentView.addSubview(checkImgView)
        contentView.addSubview(nameLab)
//        contentView.addSubview(noteLab)
        contentView.addSubview(userImgView)
//        contentView.addSubview(dateLab)
        
        checkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(checkImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(userImgView)
            make.right.equalTo(-kMargin)
        }
//        noteLab.snp.makeConstraints { (make) in
//            make.right.equalTo(-kMargin)
//            make.top.equalTo(nameLab)
//            make.width.equalTo(120)
//            make.height.equalTo(20)
//        }
//        dateLab.snp.makeConstraints { (make) in
//            make.top.equalTo(noteLab.snp.bottom)
//            make.right.width.height.equalTo(noteLab)
//        }
    }
    
    /// 选择框
    lazy var checkImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_check_circle"))
    /// 图标
    lazy var userImgView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.cornerRadius = 20
        
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
//    lazy var noteLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k12Font
//        lab.textColor = kHeightGaryFontColor
//        lab.textAlignment = .right
//        lab.text = "备注：营养不良"
//
//        return lab
//    }()
//    /// 日期
//    var dateLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k12Font
//        lab.textColor = kHeightGaryFontColor
//        lab.textAlignment = .right
//        lab.text = "添加于2018-08-07"
//
//        return lab
//    }()
}
