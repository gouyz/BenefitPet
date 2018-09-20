//
//  BPSchoolCell.swift
//  BenefitPet
//  兽医学院cell
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSchoolCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(bgImgView)
        bgImgView.addSubview(titleLab)
        bgView.addSubview(desLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(contentView)
        }
        
        bgImgView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo((kScreenWidth - 60)/2 * 0.75)
        }
        titleLab.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgImgView)
            make.top.equalTo(bgImgView.snp.bottom)
            make.bottom.equalTo(-kMargin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    /// 图片
    lazy var bgImgView : UIImageView = UIImageView()
    /// title
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.backgroundColor = UIColor.clear
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.font = k18Font
        
        return lab
    }()
    
    /// des
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.font = k13Font
        
        return lab
    }()
}
