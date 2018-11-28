//
//  BPAddRiChengVC.swift
//  BenefitPet
//  添加日程
//  Created by gouyz on 2018/8/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPAddRiChengVC: GYZBaseVC {
    
    /// 选择患者
    var selectHuanZheModel: BPHuanZheModel?
    /// 选择结果回调
    var resultBlock:(() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加日程"
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
        view.addSubview(dateView)
        view.addSubview(lineView1)
        view.addSubview(timeView)
        view.addSubview(lineView2)
        view.addSubview(huanzheView)
        view.addSubview(rightIconView)
        view.addSubview(lineView3)
        view.addSubview(dealView)
        view.addSubview(lineView4)
        
        dateView.snp.makeConstraints { (make) in
            make.right.left.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(50)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(dateView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        timeView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(dateView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(timeView.snp.bottom)
        }
        huanzheView.snp.makeConstraints { (make) in
            make.left.height.equalTo(dateView)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(lineView2.snp.bottom)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(huanzheView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(huanzheView.snp.bottom)
        }
        dealView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(dateView)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(dealView.snp.bottom)
        }
    }
   
    /// 日期
    lazy var dateView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "日期"
        view.textFiled.placeholder = "未填写"
        view.textFiled.isEnabled = false
        view.addOnClickListener(target: self, action: #selector(onClickedDate))
        
        return view
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 时间
    lazy var timeView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "时间"
        view.textFiled.placeholder = "未填写"
        view.textFiled.isEnabled = false
        view.addOnClickListener(target: self, action: #selector(onClickedTime))
        
        return view
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 患者
    lazy var huanzheView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "患者"
        view.textFiled.placeholder = "未填写"
        view.textFiled.isEnabled = false
        
        view.addOnClickListener(target: self, action: #selector(onClickedSelectedHuanZhe))
        
        return view
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线
    var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 安排
    lazy var dealView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "安排"
        view.textFiled.placeholder = "未填写"
        
        return view
    }()
    /// 分割线
    var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 保存
    @objc func onClickRightBtn(){
        if selectHuanZheModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择患者")
            return
        }
        if (dateView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请选择日期")
            return
        }
        if (timeView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请选择时间")
            return
        }
        if (dealView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请填写安排")
            return
        }
        requestAddRiChengList()
    }
    /// 添加日程
    func requestAddRiChengList(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctorindex/add_Richeng", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","date": dateView.textFiled.text!,"time":timeView.textFiled.text!,"richeng": dealView.textFiled.text!,"u_id":(selectHuanZheModel?.id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.backRefreshData()
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 回传，刷新数据
    func backRefreshData(){
        /// 发布通知, 完成订单后，刷新待办
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSendMessageData), object: nil,userInfo:["url" : "日程加入，请到个人中心查看"])
    }
    
    /// 选择患者
    @objc func onClickedSelectedHuanZhe(){
        let vc = BPSelectSingleHuanZheVC()
        vc.selectBlock = {[weak self] (model) in
            
            self?.selectHuanZheModel = model
            self?.huanzheView.textFiled.text = model.nickname
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择日期
    @objc func onClickedDate(){
        UsefulPickerView.showDatePicker("选择日期") { [weak self](date) in
    
            self?.dateView.textFiled.text = date.dateToStringWithFormat(format: "yyyy-MM-dd")
        }
    }
    /// 选择时间
    @objc func onClickedTime(){
        var dateStyle = DatePickerSetting()
        dateStyle.dateMode = .time
        UsefulPickerView.showDatePicker("选择时间", datePickerSetting: dateStyle) {[weak self](date) in
            
            self?.timeView.textFiled.text = date.dateToStringWithFormat(format: "HH: mm")
            
        }
    }
}
