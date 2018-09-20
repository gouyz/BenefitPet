//
//  BPBtnFooterView.swift
//  BenefitPet
//  底部按钮footer
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPBtnFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(onOperatorBtn)
        
        onOperatorBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 50, left: 20, bottom: 20, right: 20))
        }
        
    }
    ///
    lazy var onOperatorBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("添加好友", for: .normal)
        return btn
    }()
}
