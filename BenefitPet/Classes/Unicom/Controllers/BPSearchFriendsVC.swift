//
//  BPSearchFriendsVC.swift
//  BenefitPet
//  搜索好友
//  Created by gouyz on 2018/11/5.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchFriendsCell = "searchFriendsCell"

class BPSearchFriendsVC: GYZBaseVC {

    var searchContent: String = ""
    var searchType : String = "1"
    var dataList: [BPFriendModel] = [BPFriendModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "好友搜索"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestFriendsDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: searchFriendsCell)
        
        return table
    }()
    
    
    ///获取黑名单数据
    func requestFriendsDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/search",parameters: ["input": searchContent,"type": searchType,"d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
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
                    weakSelf?.showEmptyView(content: "暂无好友信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestFriendsDatas()
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
                
                weakSelf?.dataList[index].type = "3"// 设置待通过
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

extension BPSearchFriendsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchFriendsCell) as! BPSchoolFriendsCell
        let model = dataList[indexPath.row]
        model.name = model.nickname
        cell.dataModel = model
        
        /// 用于搜索时 1 好友   0 患者   2陌生好友
        let state: String = model.type!
        if state == "2" {
            cell.addBtn.isEnabled = true
            cell.addBtn.backgroundColor = kBtnClickBGColor
            cell.addBtn.setTitle("添加", for: .normal)
            cell.addBtn.setTitleColor(kWhiteColor, for: .normal)
        }else if state == "1" {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("已添加", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
        }else {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("待通过", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
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
        
        goChatVC(userId: dataList[indexPath.row].jg_id!)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
