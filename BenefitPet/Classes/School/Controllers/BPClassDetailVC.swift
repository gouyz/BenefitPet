//
//  BPClassDetailVC.swift
//  BenefitPet
//  培训班详情
//  Created by gouyz on 2018/11/3.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPClassDetailVC: GYZBaseVC {
    
    var dataModel: BPSchoolModel?
    var classId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "培训班详情"
        self.view.backgroundColor = kWhiteColor
        
        setUpUI()
        requestDetailDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        view.addSubview(nameView)
        view.addSubview(lineView1)
        view.addSubview(personView)
        view.addSubview(lineView2)
        view.addSubview(contentDesLab)
        view.addSubview(contentLab)
        
        nameView.snp.makeConstraints { (make) in
            make.right.left.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(50)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        personView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(personView.snp.bottom)
        }
        contentDesLab.snp.makeConstraints { (make) in
            make.height.equalTo(nameView)
            make.left.equalTo(kMargin)
            make.width.equalTo(80)
            make.top.equalTo(lineView2.snp.bottom)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentDesLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentDesLab)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    /// 名称
    lazy var nameView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "名称："
        view.textFiled.isEnabled = false
        
        return view
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 创建者
    lazy var personView: GYZLabAndFieldView = {
        let view = GYZLabAndFieldView()
        view.textFiled.textAlignment = .right
        view.desLab.text = "创建者："
        view.textFiled.isEnabled = false
        
        return view
    }()
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    ///
    var contentDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "内容："
        
        return lab
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
        
        GYZNetWork.requestNetwork("school/school_college_content", parameters: ["id": classId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = BPSchoolModel.init(dict: data)
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
            nameView.textFiled.text = dataModel?.classname
            personView.textFiled.text = dataModel?.founder
            contentLab.text = dataModel?.content
        }
    }
}
