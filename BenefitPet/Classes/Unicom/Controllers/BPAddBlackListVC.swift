//
//  BPAddBlackListVC.swift
//  BenefitPet
//  记录不良患者
//  Created by gouyz on 2018/8/1.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPAddBlackListVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "记录不良患者"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(bgView)
        bgView.addSubview(nameView)
        view.addSubview(noteView)
        bgView.addSubview(rightIconView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
        }
        nameView.snp.makeConstraints { (make) in
            make.left.height.top.equalTo(bgView)
            make.right.equalTo(rightIconView.snp.left)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        noteView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(nameView)
            make.top.equalTo(nameView.snp.bottom).offset(klineWidth)
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
    /// 姓名
    lazy var nameView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "姓名"
        view.textFiled.placeholder = "未选择"
        view.textFiled.isEnabled = false
        
        view.addOnClickListener(target: self, action: #selector(onClickedSelectedHuanZhe))
        
        return view
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 症状
    lazy var noteView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init(desName: "症状", placeHolder: "未填写", isPhone: false)
        lab.textFiled.textAlignment = .right
        
        return lab
    }()
    /// 保存
    @objc func onClickRightBtn(){
        
    }
    
    /// 选择患者
    @objc func onClickedSelectedHuanZhe(){
        let vc = BPSelectHuanZheVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
