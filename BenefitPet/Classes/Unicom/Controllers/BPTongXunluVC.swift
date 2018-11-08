//
//  BPTongXunluVC.swift
//  BenefitPet
//  通讯录
//  Created by gouyz on 2018/8/24.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let tongXunluCell = "tongXunluCell"

class BPTongXunluVC: GYZBaseVC {
    
    /// 通讯录数据
    var bookList: [AddressBookModel] = [AddressBookModel]()
    var dataList: [BPFriendModel] = [BPFriendModel]()
    /// 通讯录中返回的电话（用逗号分隔）
    var phoneNums: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "通讯录"
        
        let status = GYZAddressBookManager.sharedInstance.cheackAddressBookAuthorizationStatus()
        
        if status == .deniedOrRestricted {//访问限制或者拒绝 弹出设置对话框
            showAlert()
        }else if status == .notDeterMined{//从未进行过授权操作、请求授权
            GYZAddressBookManager.sharedInstance.requestAddressBookAccess { [weak self](isRight) in
                
                if isRight{//授权成功
                    self?.bookList = GYZAddressBookManager.sharedInstance.readRecords()
                }
            }
        }else{
            bookList = GYZAddressBookManager.sharedInstance.readRecords()
        }
        
        for item in bookList {
            phoneNums += item.phone! + ","
        }
        if phoneNums.count > 0 {
            phoneNums = phoneNums.subString(start: 0, length: phoneNums.count - 1)
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    
        requestFriendListDatas()
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
    
    ///获取好友数据
    func requestFriendListDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/books", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","phones": phoneNums],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPFriendModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无通讯录好友信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestFriendListDatas()
                weakSelf?.hiddenEmptyView()
            })
            
        })
    }
    
    /// 添加好友
    func requestAddFriend(index: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        let model = dataList[index]
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("contact/add_friend", parameters: ["f_id": model.id!,"d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList[index].ishad = "1"
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 患者聊天
    func goChatVC(userId: String){
        let vc = BPChatVC()
        vc.userJgId = userId
        navigationController?.pushViewController(vc, animated: true)
    }
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
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        
        cell.addBtn.isHidden = false
        cell.rightIconView.isHidden = true
        /// 好友添加状态：0未添加 1待通过 2通过
        let state: String = model.ishad!
        if state == "0" {
            cell.addBtn.isEnabled = true
            cell.addBtn.backgroundColor = kBtnClickBGColor
            cell.addBtn.setTitle("添加", for: .normal)
            cell.addBtn.setTitleColor(kWhiteColor, for: .normal)
        }else if state == "1" {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("待通过", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
        }else if state == "2" {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("已添加", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
            cell.addBtn.isHidden = true
            cell.rightIconView.isHidden = false
        }
        
        cell.addBtn.tag = indexPath.row
        cell.addBlock = { [weak self] (index) in
            self?.requestAddFriend(index: index)
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
        let model = dataList[indexPath.row]
        /// 好友添加状态：0未添加 1待通过 2通过
        if model.ishad == "2" {
            goChatVC(userId: model.jg_id!)
        }
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
