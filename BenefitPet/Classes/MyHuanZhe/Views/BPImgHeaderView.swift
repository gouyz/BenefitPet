//
//  BPImgHeaderView.swift
//  BenefitPet
//  只含有图片的table header
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPImgHeaderView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(tagImgView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin))
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = UIImageView()
}
