//
//  BPUniversityVC.swift
//  BenefitPet
//  毕业院校
//  Created by gouyz on 2018/8/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPUniversityVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    var userInfoModel: LHSUserInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "毕业院校"
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
        
        view.addSubview(nameFiled)
        view.addSubview(lineView1)
        view.addSubview(zhuanYeFiled)
        view.addSubview(lineView2)
        view.addSubview(xueWeiFiled)
        view.addSubview(lineView3)
        view.addSubview(startDateFiled)
        view.addSubview(lineView4)
        view.addSubview(endDateFiled)
        view.addSubview(lineView5)
        
        nameFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(kTitleHeight)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(nameFiled.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        zhuanYeFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameFiled)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(zhuanYeFiled.snp.bottom)
        }
        xueWeiFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameFiled)
            make.top.equalTo(lineView2.snp.bottom)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(xueWeiFiled.snp.bottom)
        }
        startDateFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameFiled)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(startDateFiled.snp.bottom)
        }
        endDateFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameFiled)
            make.top.equalTo(lineView4.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(endDateFiled.snp.bottom)
        }
    }
    
    /// 院校名称
    lazy var nameFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的毕业院校"
        textFiled.text = userInfoModel?.school
        
        return textFiled
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 专业名称
    lazy var zhuanYeFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的专业"
        textFiled.text = userInfoModel?.major
        
        return textFiled
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 学位
    lazy var xueWeiFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的学位"
        textFiled.text = userInfoModel?.degree
        
        return textFiled
    }()
    /// 分割线
    var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 入学时间
    lazy var startDateFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的入学时间"
        textFiled.text = userInfoModel?.in_school_time
        
        return textFiled
    }()
    /// 分割线
    var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 毕业时间
    lazy var endDateFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的毕业时间"
        textFiled.text = userInfoModel?.le_school_time
        
        return textFiled
    }()
    /// 分割线5
    var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 保存
    @objc func onClickRightBtn(){
        if nameFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入您的毕业院校")
            return
        }
        if zhuanYeFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入您的专业")
            return
        }
        if xueWeiFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入您的学位")
            return
        }
        if startDateFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入您的入学时间")
            return
        }
        if endDateFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入您的毕业时间")
            return
        }
        requestModifySchool()
    }

    /// 保存
    func requestModifySchool(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctor/perfect", parameters: ["id":userDefaults.string(forKey: "userId") ?? "","school":nameFiled.text!,"major": zhuanYeFiled.text!,"degree": xueWeiFiled.text!,"in_school_time": startDateFiled.text!,"le_school_time": endDateFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
