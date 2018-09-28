//
//  BPWorkingHeaderView.swift
//  BenefitPet
//  工作站header
//  Created by gouyz on 2018/7/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPWorkingHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
//        contentView.addSubview(dingYueLab)
        contentView.addSubview(nameLab)
//        contentView.addSubview(tagImgView)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(-kMargin)
        }
//        tagImgView.snp.makeConstraints { (make) in
//            make.right.equalTo(dingYueLab.snp.left).offset(-5)
//            make.centerY.equalTo(dingYueLab)
//            make.size.equalTo(CGSize.init(width: 13, height: 13))
//        }
//        dingYueLab.snp.makeConstraints { (make) in
//            make.right.equalTo(-kMargin)
//            make.top.bottom.equalTo(nameLab)
//            make.width.equalTo(80)
//        }
    }
    
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "新闻"
        
        return lab
    }()
    
    ///
//    lazy var dingYueLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k13Font
//        lab.textColor = kHeightGaryFontColor
//        lab.text = "订阅与收藏"
//
//        return lab
//    }()
//    /// 图片
//    lazy var tagImgView : UIImageView = {
//        let imgView = UIImageView()
//        imgView.image = UIImage.init(named: "icon_dingyue_tag")
//
//        return imgView
//    }()
}
