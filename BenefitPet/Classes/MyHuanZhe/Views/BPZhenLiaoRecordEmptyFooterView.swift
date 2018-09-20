//
//  BPZhenLiaoRecordEmptyFooterView.swift
//  BenefitPet
//  诊疗记录footer
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPZhenLiaoRecordEmptyFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        contentView.addSubview(contentLab)
        contentView.addSubview(iconImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 80, height: 70))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
    }
    
    lazy var iconImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_record_empty"))
    /// 内容显示
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "暂无记录"
        
        return lab
    }()

}
