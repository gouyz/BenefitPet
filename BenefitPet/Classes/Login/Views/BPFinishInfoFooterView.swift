//
//  BPFinishInfoFooterView.swift
//  BenefitPet
//  完善信息footer
//  Created by gouyz on 2018/11/8.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

class BPFinishInfoFooterView: UITableViewHeaderFooterView {
    
    /// 操作回调
    var operatorBlock:((_ index: Int) -> Void)?
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(tipsBtn)
        contentView.addSubview(finishBtn)
        
        tipsBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.equalTo((kScreenWidth - 90) * 0.5)
            make.top.equalTo(20)
            make.height.equalTo(kTitleHeight)
        }
        finishBtn.snp.makeConstraints { (make) in
            make.left.equalTo(tipsBtn.snp.right).offset(30)
            make.width.equalTo((kScreenWidth - 90) * 0.5)
            make.top.height.equalTo(tipsBtn)
        }
    }
    
    /// 跳过按钮
    lazy var tipsBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.setTitle("暂不完善，立即登录", for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        btn.tag = 101
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 完善按钮
    lazy var finishBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("已完善，立即登录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        
        btn.cornerRadius = kCornerRadius
        
        btn.tag = 102
        btn.addTarget(self, action: #selector(onClickedOperator(sender:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func onClickedOperator(sender: UIButton){
        let tag = sender.tag
        if operatorBlock != nil {
            operatorBlock!(tag)
        }
    }
}
