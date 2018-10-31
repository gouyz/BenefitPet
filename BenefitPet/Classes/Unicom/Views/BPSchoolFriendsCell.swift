//
//  BPSchoolFriendsCell.swift
//  BenefitPet
//  同届校友 cell
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPSchoolFriendsCell: UITableViewCell {
    /// 填充数据
    var dataModel : BPFriendModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.name
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    /// 添加
    var addBlock:((_ index: Int) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(addBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(addBtn.snp.left).offset(-kMargin)
        }
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 50, height: 24))
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.cornerRadius = 15
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "玛丽"
        
        return lab
    }()
    
    /// 添加按钮
    lazy var addBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("添加", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = kCornerRadius
        
        btn.addTarget(self, action: #selector(onClickedAddBtn(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 添加
    @objc func onClickedAddBtn(sender: UIButton){
        
        let tag = sender.tag
        
        if addBlock != nil {
            addBlock!(tag)
        }
    }
}
