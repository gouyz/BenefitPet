//
//  BPTongShiVC.swift
//  BenefitPet
//  同事
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let tongShiCell = "tongShiCell"

class BPTongShiVC: GYZBaseVC {
    
    var dataList: [BPFriendModel] = [BPFriendModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "同事"
        
//        view.addSubview(friendEmptyView)
//        view.addSubview(applyBtn)
        view.addSubview(tableView)
        
//        friendEmptyView.snp.makeConstraints { (make) in
//            make.edges.equalTo(0)
//        }
//
//        applyBtn.snp.makeConstraints { (make) in
//            make.left.bottom.right.equalTo(view)
//            make.height.equalTo(kBottomTabbarHeight)
//        }
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
//            make.left.right.equalTo(view)
//            make.bottom.equalTo(applyBtn.snp.top)
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(view)
//            }else{
//                make.top.equalTo(kTitleAndStateHeight)
//            }
        }

        requestFriendListDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 空页面
//    lazy var friendEmptyView: BPFriendsEmptyView = {
//        let emptyView = BPFriendsEmptyView()
//        emptyView.desLab.text = "您还没有同院同科室的医生"
//        emptyView.operatorBtn.setTitle("邀请同事", for: .normal)
//        emptyView.operatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
//
//        return emptyView
//    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: tongShiCell)
        
        return table
    }()
    
    /// 邀请同事
//    lazy var applyBtn : UIButton = {
//        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = kBtnClickBGColor
//        btn.setTitle("邀请同事", for: .normal)
//        btn.setTitleColor(kWhiteColor, for: .normal)
//        btn.titleLabel?.font = k15Font
//        btn.cornerRadius = kCornerRadius
//        btn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
//
//        return btn
//    }()
    
    ///获取好友数据
    func requestFriendListDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/colleagues", parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
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
//                weakSelf?.friendEmptyView.isHidden = true
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无同事信息")
//                    weakSelf?.view.bringSubview(toFront: (weakSelf?.applyBtn)!)
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
//                weakSelf?.friendEmptyView.isHidden = true
            })
//            weakSelf?.view.bringSubview(toFront: (weakSelf?.applyBtn)!)
        })
    }
    /// 邀请同事
//    @objc func onClickedOperatorBtn(){
//        showShareView()
//    }
//
//    /// 分享界面
//    func showShareView(){
//
//        let cancelBtn = [
//            "title": "取消",
//            "type": "danger"
//        ]
//        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
//        mmShareSheet.callBack = { [weak self](handler) ->() in
//
//            if handler != "cancel" {// 取消
//
//            }
//        }
//        mmShareSheet.present()
//    }
    
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

extension BPTongShiVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tongShiCell) as! BPSchoolFriendsCell
        
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
