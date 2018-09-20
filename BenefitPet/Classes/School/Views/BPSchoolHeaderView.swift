//
//  BPSchoolHeaderView.swift
//  BenefitPet
//  兽医学院header
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSchoolHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(headerImgView)
        
        headerImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    /// 图片
    lazy var headerImgView : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_school_header"))
}
