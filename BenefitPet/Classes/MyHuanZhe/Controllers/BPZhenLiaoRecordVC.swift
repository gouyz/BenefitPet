//
//  BPZhenLiaoRecordVC.swift
//  BenefitPet
//  同步诊疗记录
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let zhenLiaoRecordInfoCell = "zhenLiaoRecordInfoCell"
private let zhenLiaoRecordCell = "zhenLiaoRecordCell"
private let zhenLiaoRecordHeader = "zhenLiaoRecordHeader"
private let zhenLiaoRecordFooter = "zhenLiaoRecordFooter"

class BPZhenLiaoRecordVC: GYZBaseVC {
    
    var dataModel: BPZhenLiaoModel?
    var huanZheId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor

        view.addSubview(addRecordBtn)
        view.addSubview(tableView)
        addRecordBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(addRecordBtn.snp.top)
        }
        
        requestDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(GYZCommonArrowCell.self, forCellReuseIdentifier: zhenLiaoRecordCell)
        table.register(BPZhenLiaoRecordInfoCell.self, forCellReuseIdentifier: zhenLiaoRecordInfoCell)
        table.register(BPWenZhenTableHeaderView.self, forHeaderFooterViewReuseIdentifier: zhenLiaoRecordHeader)
        
        table.register(BPZhenLiaoRecordEmptyFooterView.self, forHeaderFooterViewReuseIdentifier: zhenLiaoRecordFooter)
        
        return table
    }()
    /// 添加诊疗记录
    lazy var addRecordBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("添加诊疗记录", for: .normal)
        btn.addTarget(self, action: #selector(clickedAddRecordBtn), for: .touchUpInside)
        
        return btn
    }()
    
    ///获取数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/record_page", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","u_id": huanZheId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = BPZhenLiaoModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestDatas()
            })
        })
    }
    /// 添加诊疗记录
    @objc func clickedAddRecordBtn(){
        let vc = BPAddZhenLiaoRecordVC()
        vc.huanZheId = huanZheId
        vc.resultBlock = {[weak self] () in
            
            self?.requestDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 问诊表
    func goWenZhenList(){
        let vc = BPWenZhenListVC()
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 日程和随访计划
    func goWenRiCheng(){
        let vc = BPRiChengPlanManagerVC()
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 编辑患者信息
    func goEditInfo(){
        let vc = BPEditHuanZheInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 编辑分组
    func goEditGroup(){
        let vc = BPGroupManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 诊疗记录详情
    func goZhenLiaoDetail(model: BPZhenLiaoRecordModel){
        let vc = BPZhenLiaoDetailVC()
        vc.dataModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPZhenLiaoRecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return dataModel == nil ? 0 : (dataModel?.recordList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: zhenLiaoRecordInfoCell) as! BPZhenLiaoRecordInfoCell
            
            if dataModel != nil && dataModel?.userModel != nil{
                cell.nameLab.text = dataModel?.userModel?.nickname
                cell.userImgView.kf.setImage(with: URL.init(string: (dataModel?.userModel?.head)!))
            }
            
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: zhenLiaoRecordCell) as! GYZCommonArrowCell
            if indexPath.section == 0 {
                if indexPath.row == 1{
                    cell.nameLab.text = "分组"
                    if dataModel != nil{
                        cell.contentLab.text = dataModel?.groupModel?.name
                    }
                }else if indexPath.row == 2{
                    cell.nameLab.text = "日程和随访计划"
                    cell.contentLab.text = ""
                }else if indexPath.row == 3{
                    cell.nameLab.text = "问诊表"
                    cell.contentLab.text = ""
                }
            }else{
                
                let model = dataModel?.recordList[indexPath.row]
                cell.nameLab.text = model?.see_time
                cell.contentLab.text = model?.remark
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: zhenLiaoRecordHeader) as! BPWenZhenTableHeaderView
            
            headerView.nameLab.text = "诊疗记录"
            headerView.nameLab.textColor = kBlueFontColor
            
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 && (dataModel != nil && dataModel?.recordList.count == 0) {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: zhenLiaoRecordFooter) as! BPZhenLiaoRecordEmptyFooterView
            
            return footerView
        }
        
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0://患者信息
                goEditInfo()
            case 1://分组
                goEditGroup()
            case 2://日程和随访计划
                goWenRiCheng()
            case 3://问诊表
                goWenZhenList()
            default:
                break
            }
        }else{
            goZhenLiaoDetail(model: (dataModel?.recordList[indexPath.row])!)
        }
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 64
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 34
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 && (dataModel != nil && dataModel?.recordList.count == 0){
            return 200
        }
        return 0.00001
    }
}
