//
//  BPModifySchoolVC.swift
//  BenefitPet
//  完善教育经历
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPModifySchoolVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "完善教育经历"
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
        view.addSubview(schoolNameView)
        view.addSubview(lineView)
        view.addSubview(zhuanYeView)
        view.addSubview(lineView1)
        view.addSubview(xueWeiView)
        view.addSubview(lineView2)
        view.addSubview(startDateView)
        view.addSubview(lineView3)
        view.addSubview(endDateView)
        view.addSubview(lineView4)
        
        schoolNameView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(schoolNameView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        zhuanYeView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolNameView)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(zhuanYeView.snp.bottom)
        }
        xueWeiView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolNameView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(xueWeiView.snp.bottom)
        }
        startDateView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolNameView)
            make.top.equalTo(lineView2.snp.bottom)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(startDateView.snp.bottom)
        }
        endDateView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(schoolNameView)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(endDateView.snp.bottom)
        }
        
    }
    
    /// 学校
    lazy var schoolNameView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "学校", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 专业
    lazy var zhuanYeView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "专业", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView1: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 学位
    lazy var xueWeiView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "学位", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView2: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 入学时间
    lazy var startDateView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "入学时间", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView3: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 毕业时间
    lazy var endDateView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "毕业时间", placeHolder: "未填写", isPhone: false)
        view.textFiled.textAlignment = .right
        
        return view
    }()
    lazy var lineView4: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 保存
    @objc func onClickRightBtn(){
        
    }
}
