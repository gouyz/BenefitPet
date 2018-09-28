//
//  BPMineHeaderView.swift
//  BenefitPet
//  我的 header
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPMineHeaderView: UIView {

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(bgView)
        bgView.addSubview(userHeaderView)
        bgView.addSubview(desLab)
        bgView.addSubview(moneyLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(kTitleAndStateHeight)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userHeaderView.snp.bottom)
            make.height.equalTo(30)
        }
        
        moneyLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    /// 背景
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        
        return view
    }()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_default"))
        imgView.cornerRadius = 30
        
        return imgView
    }()
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "登录/注册"
        
        return lab
    }()
    ///
    lazy var moneyLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "我的余额：￥300"
        
        return lab
    }()
}
