//
//  BPAddBlackListVC.swift
//  BenefitPet
//  记录不良患者
//  Created by gouyz on 2018/8/1.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPAddBlackListVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    /// 选择患者
    var selectHuanZheModel: BPHuanZheModel?

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
        lab.textFiled.isSecureTextEntry = false
        lab.textFiled.textAlignment = .right
        
        return lab
    }()
    /// 保存
    @objc func onClickRightBtn(){
        if selectHuanZheModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择患者")
            return
        }
        if (noteView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入患者症状")
            return
        }
        
        requestAddBlackList()
        
    }
    /// 加入黑名单
    func requestAddBlackList(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("contact/add_black_patient", parameters: ["u_id": (selectHuanZheModel?.id)!,"remark": noteView.textFiled.text!],  success: { (response) in
            
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
    
    /// 选择患者
    @objc func onClickedSelectedHuanZhe(){
        let vc = BPSelectSingleHuanZheVC()
        vc.selectBlock = {[weak self] (model) in
            
            self?.selectHuanZheModel = model
            self?.nameView.textFiled.text = model.nickname
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
