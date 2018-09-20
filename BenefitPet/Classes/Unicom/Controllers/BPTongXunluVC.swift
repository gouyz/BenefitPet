//
//  BPTongXunluVC.swift
//  BenefitPet
//  通讯录
//  Created by gouyz on 2018/8/24.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let tongXunluCell = "tongXunluCell"

class BPTongXunluVC: GYZBaseVC {
    
    /// 通讯录数据
    var dataList: [AddressBookModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "通讯录"
        
        let status = GYZAddressBookManager.sharedInstance.cheackAddressBookAuthorizationStatus()
        
        if status == .deniedOrRestricted {//访问限制或者拒绝 弹出设置对话框
            showAlert()
        }else if status == .notDeterMined{//从未进行过授权操作、请求授权
            GYZAddressBookManager.sharedInstance.requestAddressBookAccess { [weak self](isRight) in
                
                if isRight{//授权成功
                    self?.dataList = GYZAddressBookManager.sharedInstance.readRecords()
                }
            }
        }else{
            dataList = GYZAddressBookManager.sharedInstance.readRecords()
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(){
        GYZAlertViewTools.alertViewTools.showAlert(title: "开启通讯录权限", message: "请在系统设置-隐私-通讯录里允许益宠访问您的通讯录", cancleTitle: nil, viewController: self, buttonTitles: "确定")
    }
    
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: tongXunluCell)
        
        return table
    }()
}

extension BPTongXunluVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tongXunluCell) as! BPSchoolFriendsCell
        
        cell.nameLab.text = dataList[indexPath.row].name
        
        if indexPath.row % 2 == 0 {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("已添加", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
        }else{
            cell.addBtn.isEnabled = true
            cell.addBtn.backgroundColor = kBtnClickBGColor
            cell.addBtn.setTitle("添加", for: .normal)
            cell.addBtn.setTitleColor(kWhiteColor, for: .normal)
        }
        
        cell.addBtn.tag = indexPath.row
        cell.addBlock = { (index) in
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
