//
//  BPEditHuanZheInfoVC.swift
//  BenefitPet
//  编辑患者信息
//  Created by gouyz on 2018/8/17.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPEditHuanZheInfoVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "编辑患者信息"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpUI(){
        view.addSubview(numberView)
        view.addSubview(lineView)
        view.addSubview(chuangHaoView)
        view.addSubview(lineView1)
        view.addSubview(nameView)
        view.addSubview(lineView2)
        view.addSubview(sexView)
        view.addSubview(lineView3)
        view.addSubview(birthdayView)
        view.addSubview(lineView4)
        view.addSubview(phoneView)
        view.addSubview(lineView5)
        
        numberView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(numberView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        chuangHaoView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(chuangHaoView.snp.bottom)
        }
        nameView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(nameView.snp.bottom)
        }
        sexView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView2.snp.bottom)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(sexView.snp.bottom)
        }
        birthdayView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(birthdayView.snp.bottom)
        }
        phoneView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView4.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneView.snp.bottom)
        }
        
    }
    
    /// 住院号
    lazy var numberView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "住院号", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 床位号
    lazy var chuangHaoView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "床位号", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView1: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 姓名
    lazy var nameView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "姓名", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView2: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 性别
    lazy var sexView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "性别", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView3: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 出生日期
    lazy var birthdayView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "出生日期", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView4: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 联系方式
    lazy var phoneView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "联系方式", placeHolder: "未填写", isPhone: true)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView5: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 保存
    @objc func onClickRightBtn(){
        
    }
    
}
