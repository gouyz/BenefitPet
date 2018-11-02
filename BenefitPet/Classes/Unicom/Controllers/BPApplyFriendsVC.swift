//
//  BPApplyFriendsVC.swift
//  BenefitPet
//  好友请求
//  Created by gouyz on 2018/8/24.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let applyFriendsCell = "applyFriendsCell"

class BPApplyFriendsVC: GYZBaseVC {
    
    var dataList: [BPFriendModel] = [BPFriendModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "好友请求"
        view.addSubview(friendEmptyView)
        view.addSubview(tableView)
        
        friendEmptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        requestFriendListDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 空页面
    lazy var friendEmptyView: BPFriendsEmptyView = {
        let emptyView = BPFriendsEmptyView()
        emptyView.desLab.text = "您还没有好友请求"
        emptyView.operatorBtn.setTitle("添加好友", for: .normal)
        emptyView.operatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return emptyView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: applyFriendsCell)
        
        return table
    }()
    /// 添加好友
    @objc func onClickedOperatorBtn(){
        let vc = BPAddFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取好友数据
    func requestFriendListDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/request_friend", parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
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
                    weakSelf?.friendEmptyView.isHidden = true
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.friendEmptyView.isHidden = false
                    weakSelf?.tableView.isHidden = true
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
                weakSelf?.friendEmptyView.isHidden = true
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
        
        GYZNetWork.requestNetwork("contact/pass_friend", parameters: ["f_id": model.id!,"d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList[index].ishad = "2"
                weakSelf?.tableView.reloadData()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension BPApplyFriendsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: applyFriendsCell) as! BPSchoolFriendsCell
        let model = dataList[indexPath.row]
        cell.dataModel = model
        
        /// 好友添加状态：0未添加 1待通过 2通过
        let state: String = model.ishad!
        if state == "1" {
            cell.addBtn.isEnabled = true
            cell.addBtn.backgroundColor = kBtnClickBGColor
            cell.addBtn.setTitle("接受", for: .normal)
            cell.addBtn.setTitleColor(kWhiteColor, for: .normal)
        }else{
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("已添加", for: .normal)
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

