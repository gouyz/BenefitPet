//
//  BPZhenLiaoDetailVC.swift
//  BenefitPet
//  诊疗详情
//  Created by gouyz on 2018/11/3.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPZhenLiaoDetailVC: GYZBaseVC {

    var dataModel: BPZhenLiaoRecordModel?
    var zhenLiaoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "诊疗详情"
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
        requestDetailDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        view.addSubview(dateView)
        view.addSubview(lineView1)
        view.addSubview(contentLab)
        
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
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView1.snp.bottom)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    /// 就诊时间
    lazy var dateView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "就诊时间："
        view.textFiled.isEnabled = false
        
        return view
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    
    
    ///获取详情数据
    func requestDetailDatas(){

        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("patient/record_check", parameters: ["id": zhenLiaoId],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            if response["status"].intValue == kQuestSuccessTag{//请求成功

                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = BPZhenLiaoRecordModel.init(dict: data)
                weakSelf?.loadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }

        }, failture: { (error) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func loadData(){
        if dataModel != nil {
            dateView.textFiled.text = dataModel?.see_time
            contentLab.text = dataModel?.remark
        }
    }
}
