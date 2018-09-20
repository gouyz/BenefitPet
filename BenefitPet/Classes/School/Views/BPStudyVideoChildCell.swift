//
//  BPStudyVideoChildCell.swift
//  BenefitPet
//  学习园地 专家课网 子cell
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPStudyVideoChildCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        addSubview(iconView)
        iconView.addSubview(playImgView)
        addSubview(desLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(desLab.snp.top)
        }
        playImgView.snp.makeConstraints { (make) in
            make.center.equalTo(iconView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.bottom.equalTo(self)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 图片
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    /// 播放图片
    lazy var playImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_video_play"))
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k10Font
        lab.textAlignment = .center
        lab.text = "如何清理宠物身上细菌"
        
        return lab
    }()
}
