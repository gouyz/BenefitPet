//
//  BPMyTeamHeaderView.swift
//  BenefitPet
//  我的团队 header
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPMyTeamHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(lineView)
        addSubview(nameLab)
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.width.equalTo(4)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(self)
        }
    }
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        
        return line
    }()
    /// 标题
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
}
