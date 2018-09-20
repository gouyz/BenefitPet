//
//  BPAddBankCardVC.swift
//  BenefitPet
//  添加银行卡
//  Created by gouyz on 2018/8/15.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPAddBankCardVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加银行卡"
        view.addSubview(bgView)
        bgView.addSubview(personLab)
        bgView.addSubview(personField)
        bgView.addSubview(lineView)
        bgView.addSubview(cardNoLab)
        bgView.addSubview(cardNoField)
        bgView.addSubview(lineView1)
        bgView.addSubview(nameLab)
        bgView.addSubview(iconView)
        bgView.addSubview(bankNameLab)
        bgView.addSubview(lineView2)
        view.addSubview(saveBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
        }
        personLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        personField.snp.makeConstraints { (make) in
            make.left.equalTo(personLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(personLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(personLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        cardNoLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView.snp.bottom)
        }
        cardNoField.snp.makeConstraints { (make) in
            make.left.right.equalTo(personField)
            make.top.bottom.equalTo(cardNoLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardNoLab.snp.bottom)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView1.snp.bottom)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(personField)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        bankNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.height.equalTo(nameLab)
            make.right.equalTo(personField)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(nameLab.snp.bottom)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(lineView2.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///
    lazy var personLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "持卡人"
        
        return lab
    }()
    
    /// 输入内容
    lazy var personField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请绑定本人的银行卡"
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///
    lazy var cardNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "卡号"
        
        return lab
    }()
    
    /// 输入内容
    lazy var cardNoField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入您的银行卡号"
        textFiled.keyboardType = .numberPad
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "银行"
        
        return lab
    }()
    
    /// 图标
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_bank_jianse"))
    
    /// 银行名称
    lazy var bankNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "建设银行"
        
        return lab
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    
    
    /// 完 成
    lazy var saveBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("完 成", for: .normal)
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 保存
    @objc func clickedSaveBtn(){
        
        if (cardNoField.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入银行卡号")
            return
        }
        if !GYZCheckTool.isBankCard(cardNoField.text!){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的银行卡号")
            return
        }
        //除去前后空格,防止只输入空格的情况
//        let content = contentField.text?.trimmingCharacters(in: .whitespaces)
//        if (content?.isEmpty)! {
//            MBProgressHUD.showAutoDismissHUD(message: "请输入银行卡开户行")
//            return
//        }
        
    }
}
