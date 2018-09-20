//
//  BPGroupImgCell.swift
//  BenefitPet
//  分组用户头像
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPGroupImgCell: UICollectionViewCell {
    
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
        addSubview(deleteImgView)
        
        userImgView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        deleteImgView.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
    }
    
    /// 图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = (kScreenWidth - 5 * kMargin) * 0.125
        
        return imgView
    }()
    
    /// 删除
    lazy var deleteImgView : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_group_delete"))
}
