//
//  BPLoginVC.swift
//  BenefitPet
//  登录
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPLoginVC: GYZBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "登  录"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        
        registerBtn.set(image: UIImage.init(named: "icon_register_arrow"), title: "立即注册", titlePosition: .left, additionalSpacing: kMargin, state: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(lineView)
        view.addSubview(pwdInputView)
        view.addSubview(lineView1)
        view.addSubview(loginBtn)
        view.addSubview(forgetPwdBtn)
        view.addSubview(registerBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight * 2)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom).offset(30)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(kUIButtonHeight)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(loginBtn)
            make.top.equalTo(loginBtn.snp.bottom).offset(30)
        }
        forgetPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(registerBtn.snp.bottom).offset(20)
            make.right.equalTo(loginBtn)
            make.size.equalTo(CGSize(width:70,height:20))
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
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入密码", isPhone: false)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 忘记密码按钮
    fileprivate lazy var forgetPwdBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("忘记密码?", for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(clickedForgetPwdBtn), for: .touchUpInside)
        return btn
    }()
    /// 登录按钮
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("登  录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedLoginBtn), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        return btn
    }()
    
    /// 注册按钮
    fileprivate lazy var registerBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedRegister), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    
    /// 注册
    @objc func onClickedRegister(){
        let forgetPwdVC = BPRegisterVC()
        forgetPwdVC.registerType = .register
        navigationController?.pushViewController(forgetPwdVC, animated: true)
    }
    /// 登录
    @objc func clickedLoginBtn() {
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        
        requestLogin()
    }
    /// 忘记密码
    @objc func clickedForgetPwdBtn() {
        let forgetPwdVC = BPRegisterVC()
        forgetPwdVC.registerType = .forgetpwd
        navigationController?.pushViewController(forgetPwdVC, animated: true)
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
    /// 隐藏键盘
    func hiddenKeyBoard(){
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
    }
    
    /// 登录
    func requestLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("doctor/login", parameters: ["plone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!],  success: { (response) in
            
//            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["plone"].stringValue, forKey: "phone")//用户电话
                let userName: String = data["jg_id"].stringValue
                
                weakSelf?.userLogin(userName: userName, password:"111111")
                
//                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 极光IM登录
    private func userLogin(userName: String, password: String) {
        weak var weakSelf = self
        
        JMSGUser.login(withUsername: userName, password: password) { (result, error) in
            weakSelf?.hud?.hide(animated: true)
            if error == nil {
                userDefaults.set(userName, forKey: kLastUserName)
                JMSGUser.myInfo().thumbAvatarData({ (data, id, error) in
                    if let data = data {
                        let imageData = NSKeyedArchiver.archivedData(withRootObject: data)
                        userDefaults.set(imageData, forKey: kLastUserAvator)
                    } else {
                        userDefaults.removeObject(forKey: kLastUserAvator)
                    }
                })
                
                userDefaults.set(userName, forKey: kCurrentUserName)
                userDefaults.set(password, forKey: kCurrentUserPassword)
                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else {
                MBProgressHUD.showAutoDismissHUD(message: "\(String.errorAlert(error! as NSError))")
            }
        }
    }
}
