//
//  BPCashVC.swift
//  BenefitPet
//  我的提现
//  Created by gouyz on 2018/8/15.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPCashVC: GYZBaseVC {

    ///修改价格时输入是否有小数点
    var isHaveDian: Bool = false
    ///修改价格时输入第一位是否是0
    var isFirstZero: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的提现"
        
        let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight))
        rightBtn.setTitle("提现记录", for: .normal)
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.titleLabel?.font = k14Font
        rightBtn.addTarget(self, action: #selector(onClickedCashRecord), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        setUpUI()
        cashField.delegate = self
        
        bgBankView.isHidden = true
//        requestUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(bgEmptyBankView)
        bgEmptyBankView.addSubview(checkBankLab)
        bgEmptyBankView.addSubview(rightIconView)
        
        view.addSubview(bgBankView)
        bgBankView.addSubview(iconView)
        bgBankView.addSubview(nameLab)
        bgBankView.addSubview(numberLab)
        bgBankView.addSubview(rightIconView1)
        
        view.addSubview(bgView)
        bgView.addSubview(cashLab)
        bgView.addSubview(moneyUnitLab)
        bgView.addSubview(cashField)
        bgView.addSubview(lineView)
        bgView.addSubview(cashMoneyLab)
        bgView.addSubview(allCashBtn)
        view.addSubview(saveBtn)
        
        bgEmptyBankView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(60)
        }
        checkBankLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.height.equalTo(30)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        
        bgBankView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(60)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgBankView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(rightIconView1.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        rightIconView1.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(120 + klineWidth)
            make.top.equalTo(kMargin * 2 + kTitleAndStateHeight + 60)
        }
        cashLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        moneyUnitLab.snp.makeConstraints { (make) in
            make.left.equalTo(cashLab)
            make.top.equalTo(cashLab.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(30)
        }
        cashField.snp.makeConstraints { (make) in
            make.left.equalTo(moneyUnitLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(moneyUnitLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(cashLab)
            make.top.equalTo(moneyUnitLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        cashMoneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(cashLab)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(40)
            make.right.equalTo(allCashBtn.snp.left).offset(-kMargin)
            
        }
        allCashBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(cashMoneyLab)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(bgView.snp.bottom).offset(30)
            make.height.equalTo(kBottomTabbarHeight)
        }
    }
    
    //// 未选择银行卡显示
    lazy var bgEmptyBankView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        view.addOnClickListener(target: self, action: #selector(onClickedSelectBank))
        
        return view
    }()
    
    /// 选择银行卡
    var checkBankLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "选择银行卡"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 选择银行卡显示
    lazy var bgBankView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.addOnClickListener(target: self, action: #selector(onClickedSelectBank))
        
        return view
    }()
    /// 图标
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_bank_jianse"))
    
    /// 银行名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "建设银行"
        
        return lab
    }()
    
    /// 银行卡尾号
    var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "尾号4578储蓄卡"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 提现金额
    lazy var cashLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "提现金额（收取0.1%的手续费）"
        
        return lab
    }()
    /// 提现金额单位
    lazy var moneyUnitLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kBlackFontColor
        lab.text = "￥"
        
        return lab
    }()
    
    /// 输入内容
    lazy var cashField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k18Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入提现金额"
        textFiled.keyboardType = .decimalPad
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 可提现金额
    lazy var cashMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "可用余额￥1000"
        
        return lab
    }()
    /// 全部提现
    lazy var allCashBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("全部提现", for: .normal)
        btn.addTarget(self, action: #selector(clickedAllCashBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 提  现
    lazy var saveBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确认提现", for: .normal)
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 选择银行卡
    @objc func onClickedSelectBank(){
        let vc = BPMyBankVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 提现
    @objc func clickedSaveBtn(){
        
        if (cashField.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入提现金额")
            return
        }
//        if Double.init(cashField.text!) > Double.init((userInfo?.dealerCommissionBalance)!) {
//            MBProgressHUD.showAutoDismissHUD(message: "提现金额不能大于可提现金额")
//            return
//        }
        
//        if Double.init(cashField.text!) < kMinCashMoney {
//            MBProgressHUD.showAutoDismissHUD(message: "提现金额不能小于\(kMinCashMoney)元")
//            return
//        }
        
//        requestApplyCash()
    }
    /// 佣金提现申请
//    func requestApplyCash(){
//
//        if !GYZTool.checkNetWork() {
//            return
//        }
//
//        weak var weakSelf = self
//        createHUD(message: "加载中...")
//
//        var params:[String: Any] = [String: Any]()
//        params["dealerNumber"] = userInfo?.dealerNumber
//        params["drawcashTotals"] = cashField.text!
//        params["approveStatus"] = "0"
//
//        GYZNetWork.requestNetwork("drawcash/drawcashApply.do", parameters: params,  success: { (response) in
//
//            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
//
//            MBProgressHUD.showAutoDismissHUD(message: response["message"].stringValue)
//            if response["code"].intValue == kQuestSuccessTag{//请求成功
//
//                weakSelf?.clickedBackBtn()
//            }
//
//        }, failture: { (error) in
//            weakSelf?.hud?.hide(animated: true)
//            GYZLog(error)
//        })
//    }
    /// 全部提现
    @objc func clickedAllCashBtn(){
        
        cashField.text = "1000"
    }
    
    /// 提现记录
    @objc func onClickedCashRecord(){
        
        let recordVC = BPCashRecordManagerVC()
        navigationController?.pushViewController(recordVC, animated: true)
    }
}

extension BPCashVC: UITextFieldDelegate{
    ////  MARK: UITextFieldDelegate
    //1.要求用户输入首位不能为小数点;
    //2.小数点后不超过两位，小数点无法输入超过一个;
    //3.如果首位为0，后面仅能输入小数点
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if ((textField.text?.range(of: ".")) == nil) {//是否输入点.
            isHaveDian = false
        }
        if ((textField.text?.range(of: "0")) == nil) {//首位是否输入0.
            isFirstZero = false
        }
        
        if string.count > 0 {
            //当前输入的字符
            let single = string[string.startIndex]
            //数据格式正确
            if (single >= "0" && single <= "9") || single == "." {
                if textField.text?.count == 0 {
                    //首字母不能为小数点
                    if single == "." {
                        return false
                    }else if single == "0" {
                        isFirstZero = true
                        return true
                    }
                }else{
                    if single == "." {
                        if isHaveDian {//不允许输入多个小数点
                            return false
                        } else {//text中还没有小数点
                            isHaveDian = true
                            return true
                        }
                    }else if single == "0" {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if (isHaveDian && isFirstZero) || (!isFirstZero && isHaveDian) {
                            
                            if textField.text == "0.0" {
                                return false
                            }
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }else{
                        if isHaveDian {//存在小数点，保留两位小数
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }
                }
            }else{
                //输入的数据格式不正确
                return false
            }
        }else{
            return true
        }
        return true
    }
}
