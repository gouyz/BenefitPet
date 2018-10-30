//
//  BPAddClassVC.swift
//  BenefitPet
//  创建培训班
//  Created by gouyz on 2018/8/21.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPAddClassVC: GYZBaseVC {
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    ///txtView 提示文字
    let placeHolder = "填写培训班内容（0~500字）"
    // 内容
    var content: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "创建培训班"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        contentTxtView.delegate = self
        contentTxtView.text = placeHolder
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        view.addSubview(bgView)
        bgView.addSubview(dateView)
        bgView.addSubview(lineView)
        bgView.addSubview(desLab)
        bgView.addSubview(contentTxtView)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight * 2 + 180)
        }
        dateView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(dateView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(desLab.snp.bottom)
            make.bottom.equalTo(-kMargin)
        }
    }
    
    lazy var bgView: UIView = {
        
        let line = UIView()
        line.backgroundColor = kWhiteColor
        
        return line
    }()
    
    /// 日期
    lazy var dateView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView.init(desName: "名称：", placeHolder: "如：急救培训班", isPhone: false)
        view.textFiled.textAlignment = .right
        view.textFiled.isSecureTextEntry = false
        
        return view
    }()
    lazy var lineView: UIView = {
        
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "内容："
        
        return lab
    }()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        
        return txtView
    }()
    /// 保存
    @objc func onClickRightBtn(){
        
        if (dateView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入培训班名称")
            return
        }
        if content.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入培训班内容")
            return
        }
        requestCreateClass()
    }
    
    /// 创建培训班
    func requestCreateClass(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("school/school_college_add", parameters: ["f_id": userDefaults.string(forKey: "userId") ?? "","founder":userDefaults.string(forKey: "userName") ?? "","classname": dateView.textFiled.text!,"content": content],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
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

extension BPAddClassVC : UITextViewDelegate
{
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kBlackFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        content = textView.text
    }
}
