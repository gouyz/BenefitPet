//
//  BPMyTeamCell.swift
//  BenefitPet
//  我的团队cell
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPMyTeamCell: UICollectionViewCell {
    /// 填充数据
    var dataModel : BPFriendModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.name
                userImgView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(userImgView)
        addSubview(nameLab)
        
        userImgView.snp.makeConstraints { (make) in
            
            make.top.equalTo(5)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - 6 * klineWidth) * 0.2 - 2 * kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(userImgView.snp.bottom)
            make.left.right.equalTo(userImgView)
            make.bottom.equalTo(self)
        }
    }
    
    /// 图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = (kScreenWidth - 6 * klineWidth) * 0.1 - kMargin
        imgView.image = UIImage.init(named: "icon_header_default")
        
        return imgView
    }()
    
    /// name
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.font = k10Font
        lab.text = "丽莎"
        
        return lab
    }()
}
