//
//  BPGroupManagerVC.swift
//  BenefitPet
//  分组管理
//  Created by gouyz on 2018/8/17.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPGroupManagerVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    var groupArr: [String] = [String]()
    /// 分类高度
    var groupHeight: CGFloat = 0
    var selectedGroup: BPHuanZheGroupModel?
    /// 患者群组
    var dataList: [BPHuanZheGroupModel] = [BPHuanZheGroupModel]()
    var huanZheId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "分组管理"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        allGroupTagsView.completion = {[weak self] (tags,index) in
            self?.selectedGroup = self?.dataList[index]
        }
        
        requestGroupDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(desLab)
        view.addSubview(allGroupTagsView)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(kTitleHeight)
        }
        
        allGroupTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(0)
        }
    }
    /// 所有分组
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "全部分组"
        
        return lab
    }()
    /// 所有分组
    lazy var allGroupTagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        view.tagAttribute.cornerRadius = kCornerRadius
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    ///获取医生所有分组数据
    func requestGroupDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/doctor_group",parameters: ["d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPHuanZheGroupModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                    weakSelf?.groupArr.append(model.name!)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.setData()
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
        })
    }
    
    func setData(){
        groupHeight = HXTagsView.getHeightWithTags(groupArr, layout: allGroupTagsView.layout, tagAttribute: allGroupTagsView.tagAttribute, width: kScreenWidth)
        
        allGroupTagsView.snp.updateConstraints { (make) in
            make.height.equalTo(groupHeight)
        }
        allGroupTagsView.tags = groupArr
        if selectedGroup != nil {
            allGroupTagsView.selectedTags = [(selectedGroup?.name)!]
        }
        allGroupTagsView.reloadData()
    }
    /// 保存
    @objc func onClickRightBtn(){
        
        if selectedGroup == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择分组")
            return
        }
        
        requestSaveData()
    }
    
    /// 保存
    func requestSaveData(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/save_patient_group", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","group_id": (selectedGroup?.id)!,"u_id":huanZheId],  success: { (response) in
            
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
