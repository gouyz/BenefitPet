//
//  BPRegisterVC.swift
//  BenefitPet
//  注册、忘记密码、修改密码
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

public enum RegisterVCType : Int {
    
    
    case register // 注册
    
    case forgetpwd // 忘记密码
    
    case modifypwd // 修改密码
}

class BPRegisterVC: GYZBaseVC {
    
    /// 类型
    var registerType: RegisterVCType = .register

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        setupUI()

        var title: String = "注 册"
        if registerType == .forgetpwd {
            title = "忘记密码"
        }else if registerType == .modifypwd {
            title = "修改密码"
        }
        self.navigationItem.title = title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(lineView)
        view.addSubview(bgView)
        bgView.addSubview(codeInputView)
        bgView.addSubview(codeBtn)
        bgView.addSubview(lineView1)
        view.addSubview(pwdInputView)
        view.addSubview(lineView2)
        view.addSubview(repwdInputView)
        view.addSubview(lineView3)
        view.addSubview(okBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(20 + kTitleAndStateHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        codeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(bgView)
            make.right.equalTo(codeBtn.snp.left).offset(-kMargin)
            make.bottom.equalTo(lineView1.snp.top)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.bottom.equalTo(bgView)
            make.height.equalTo(lineView)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        repwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(repwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom).offset(30)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(kUIButtonHeight)
        }
        
    }
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 验证码
    fileprivate lazy var codeInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_code", placeHolder: "请输入验证码", isPhone: true)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        return view
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 确认密码
    fileprivate lazy var repwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请再次输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 获取验证码按钮
    fileprivate lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发送验证码", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k14Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedCodeBtn(btn:)), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 确定按钮
    fileprivate lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确 认", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedOkBtn(btn:)), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    
    /// 忘记密码
    @objc func clickedOkBtn(btn: UIButton){
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        if codeInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        if repwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入确认密码")
            return
        }
        if (pwdInputView.textFiled.text != repwdInputView.textFiled.text){
            MBProgressHUD.showAutoDismissHUD(message: "密码和确认密码不一致")
            return
        }
        
        if registerType == .register {//注册
            requestRegister()
        }else{//忘记/修改密码
            requestUpdatePwd()
        }
        
    }
    /// 判断手机号是否有效
    ///
    /// - Returns:
    func validPhoneNO() -> Bool{
        
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return false
        }
        if phoneInputView.textFiled.text!.isMobileNumber(){
            return true
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return false
        }
        
    }
    /// 获取验证码
    @objc func clickedCodeBtn(btn: UIButton){
        hiddenKeyBoard()
        if validPhoneNO() {
            requestCode()
        }
    }
    
    /// 找回密码
    func requestUpdatePwd(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctor/change_password", parameters: ["plone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!,"passagain": repwdInputView.textFiled.text!,"code":codeInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 注册
    func requestRegister(){
        
        weak var weakSelf = self
        createHUD(message: "注册中...")
        
        GYZNetWork.requestNetwork("doctor/register", parameters: ["plone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!,"passagain": repwdInputView.textFiled.text!,"code":codeInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["plone"].stringValue, forKey: "phone")//用户电话
                userDefaults.set(data["name"].stringValue, forKey: "userName")//用户姓名
                
                let userName: String = data["jg_id"].stringValue
                let info: JMSGUserInfo = JMSGUserInfo()
                info.nickname = data["plone"].stringValue
                /// 极光IM 注册
                JMSGUser.register(withUsername: userName, password: "111111", userInfo: info) { (result, error) in
                    let _ = DispatchQueue.main.async {
                       
                        if error == nil {
                            weakSelf?.userLogin(withUsername: userName, password: "111111")
                        }
                    }
                }
                
                weakSelf?.goFinishInfo()
//                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 完善信息
    func goFinishInfo() {
        let vc = BPFinishInfoVC()
        vc.isRegister = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 极光IM登录
    private func userLogin(withUsername: String, password: String) {
        JMSGUser.login(withUsername: withUsername, password: password) { (result, error) in
            
            if error == nil {
                userDefaults.set(withUsername, forKey: kLastUserName)
                userDefaults.set(withUsername, forKey: kCurrentUserName)
                
            } else {
//                MBProgressHUD.showAutoDismissHUD(message: "极光IM登录失败")
            }
        }
    }
    
    /// 隐藏键盘
    func hiddenKeyBoard(){
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
        codeInputView.textFiled.resignFirstResponder()
    }
    
    ///获取验证码
    func requestCode(){
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("doctor/sms_send1", parameters: ["plone":phoneInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.codeBtn.startSMSWithDuration(duration: 60)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["message"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
